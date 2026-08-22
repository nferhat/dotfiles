//! System to cache the results.

use std::io;
use std::path::{Path, PathBuf};

use anyhow::Context as _;
use tokio::io::{AsyncWrite, AsyncWriteExt};

/// A cacheable will make use of the FileView in Quickshell, notably with a JsonAdapter ontop of it
/// to read and make accessing the data effortless. We only update the files when needed.
pub trait Cacheable: Sized {
    // Wait the needed amount of time before updating.
    //
    // Whether you wait a static amount of time, or do something depending on the file, it's up to
    // you to handle this.
    async fn wait(&self, path: &Path);
    async fn update(&mut self) -> serde_json::Value;

    /// Runs the cacheable state.
    async fn run(&mut self, path: PathBuf) -> anyhow::Result<()> {
        let file = tokio::fs::OpenOptions::default()
            .write(true)
            .open(&path)
            .await;
        // Needed if we create a file since the mtime check will fail.
        let mut skip_first = false;
        let mut file = match file {
            Ok(file) => file,
            Err(err) if err.kind() == io::ErrorKind::NotFound => {
                skip_first = true;
                tokio::fs::OpenOptions::new()
                    .create(true)
                    .write(true)
                    .open(&path)
                    .await?
            }
            Err(err) => anyhow::bail!(err),
        };

        loop {
            // First wait. This does a check if the path/data is recent enough, to avoid
            // needlessly updating data that is fine to use.
            if skip_first {
                skip_first = false
            } else {
                self.wait(&path).await;
            }

            let value = self.update().await;
            let str = serde_json::to_string(&value).unwrap();
            if let Err(err) = file.write_all(str.as_bytes()).await {
                warn!(?err, path = %path.display(), "failed to update cacheable");
            }
        }
    }
}
