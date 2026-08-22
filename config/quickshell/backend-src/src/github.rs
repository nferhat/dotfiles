use std::path::Path;
use std::time::Duration;

use anyhow::Context as _;
use serde::Serialize;
use tokio::process::Command;
use tokio::time::sleep;

use crate::cached::Cacheable;

// Raw API types, not meant to be exposed.
// Not a complete schema, this is just for a quick preview.
mod raw {
    use serde::Deserialize;

    #[derive(Deserialize, Debug)]
    pub struct Notification {
        pub repository: Repository,
        pub subject: Subject,
    }

    #[derive(Deserialize, Debug)]
    pub struct Repository {
        pub full_name: String,
        pub fork: bool,
    }

    #[derive(Deserialize, Debug)]
    pub enum SubjectType {
        PullRequest,
        Issue,
        Discussion,
    }

    #[derive(Deserialize, Debug)]
    pub struct Subject {
        pub title: String,
        #[serde(rename = "type")]
        pub suject_type: SubjectType,
        /// The follow up URL to get more information about the subject.
        pub url: String,
    }
}

/// Get the Bearer authorization token from the GitHub CLI.
///
/// I know there's octocrab, but for such a simple "service", some few reqwest calls will do the
/// job.
async fn get_github_token() -> anyhow::Result<String> {
    let output = Command::new("gh").args(["auth", "token"]).output().await?;

    if !output.status.success() {
        anyhow::bail!(
            "gh auth token failed: {}",
            String::from_utf8_lossy(&output.stderr)
        );
    }

    Ok(String::from_utf8(output.stdout)?.trim().to_string())
}

#[derive(Serialize, Debug, PartialEq)]
pub enum PullRequestStatus {
    Open,
    Closed,
    Merged,
}

/// A single notification
#[derive(Serialize, Debug, PartialEq)]
#[serde(tag = "kind", content = "data")]
pub enum Notification {
    PullRequest {
        /// The full repository name, `author/repo`
        repository: String,
        /// Whether this repository is a fork or not.
        fork: bool,
        /// The author of the pull request.
        author: String,
        /// The pull request title.
        title: String,
        /// The pull request number.
        number: u64,
        /// The pull request status.
        status: PullRequestStatus,
    },
    Issue {
        /// The full repository name, `author/repo`
        repository: String,
        /// The author of the issue
        author: String,
        /// The issue title.
        title: String,
        /// The issue number.
        number: u64,
        /// Whether the issue is closed.
        closed: bool,
        /// Whether the issue is marked as completed.
        completed: bool,
    },
    Discussion {
        /// The full repository name, `author/repo`
        repository: String,
        /// The author of the issue
        author: String,
        /// The issue title.
        title: String,
    },
}

#[derive(Default)]
pub struct GitHubNotifications {
    client: reqwest::Client,
    token: String,
    last_is_err: bool,
}

impl GitHubNotifications {
    pub async fn new() -> anyhow::Result<Self> {
        let client = reqwest::Client::default();
        let token = get_github_token()
            .await
            .context("failed to get github bearer token")?;
        Ok(Self {
            client,
            token,
            last_is_err: false,
        })
    }

    async fn get_notifications(&self) -> anyhow::Result<Vec<Notification>> {
        let resp = self
            .client
            .get("https://api.github.com/notifications?all=true")
            .bearer_auth(&self.token)
            .header("User-Agent", "qs-backend")
            .send()
            .await?;

        let raw = resp
            .json::<Vec<raw::Notification>>()
            .await
            .context("failed to parse notifications")?;

        let mut notifications = Vec::with_capacity(raw.len());
        for raw in raw {
            let Ok(res) = self
                .client
                .get(&raw.subject.url)
                .bearer_auth(&self.token)
                .header("User-Agent", "qs-backend")
                .send()
                .await
            else {
                continue;
            };
            let Ok(details) = res.json::<serde_json::Value>().await else {
                continue;
            };
            let author = details["user"]["login"].as_str().unwrap().to_string();
            let number = details["number"].as_u64().unwrap();

            let res = match raw.subject.suject_type {
                raw::SubjectType::PullRequest => {
                    let merged = details["merged"].as_bool().unwrap();
                    let status = if merged {
                        PullRequestStatus::Merged
                    } else if details["state"].as_str().unwrap() == "closed" {
                        PullRequestStatus::Closed
                    } else {
                        PullRequestStatus::Open
                    };

                    Notification::PullRequest {
                        repository: raw.repository.full_name,
                        fork: raw.repository.fork,
                        author,
                        title: raw.subject.title,
                        number,
                        status,
                    }
                }

                raw::SubjectType::Issue => {
                    let closed = details["state"].as_str().unwrap() == "closed";
                    let completed = details["state_reason"]
                        .as_str()
                        .map_or_default(|r| r == "completed");

                    Notification::Issue {
                        repository: raw.repository.full_name,
                        author,
                        title: raw.subject.title,
                        number,
                        closed,
                        completed,
                    }
                }
                raw::SubjectType::Discussion => Notification::Discussion {
                    repository: raw.repository.full_name,
                    author,
                    title: raw.subject.title,
                },
            };

            notifications.push(res);
        }

        Ok(notifications)
    }
}

impl Cacheable for GitHubNotifications {
    async fn wait(&self, path: &Path) {
        if self.last_is_err {
            // Sleep less time if it was an error.
            // maybe the API was just down...? (idk its github after all)
            sleep(Duration::from_mins(5)).await;
        }

        if let Some(elapsed) = path
            .metadata()
            .and_then(|md| md.modified())
            .ok()
            .and_then(|mtime| mtime.elapsed().ok())
        {
            // Sleep the remainder duration. Try to not update too often.
            let remaining = Duration::from_hours(1).saturating_sub(elapsed);
            info!(
                sleep_time = ?remaining,
                "Found existing github notifications data that is new enough"
            );
            sleep(remaining).await;
            return;
        }

        // Do not sleep, update immediatly. This is either because there was no file, or there was
        // no error.
    }

    async fn update(&mut self) -> serde_json::Value {
        let notifications = self.get_notifications().await;
        match notifications {
            Ok(notifications) => {
                self.last_is_err = false;
                info!(len = %notifications.len(), "fetched github notifications");
                serde_json::json!({"notifications": notifications})
            }
            Err(err) => {
                self.last_is_err = true;
                warn!(?err, "failed to update github notifications");
                serde_json::json!({"notifications": []})
            }
        }
    }
}
