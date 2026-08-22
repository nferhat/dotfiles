use std::path::Path;
use std::time::Duration;

use serde::{Deserialize, Serialize};
use serde_json::json;
use tokio::time::sleep;

use crate::cached::Cacheable;

// FIXME: Use config file.
// Africa/Algiers
const LATITUDE: f64 = 36.7525;
const LONGITUDE: f64 = 3.0525;

/// We use open-meteo since it doesn't require any token and we have a generous
/// 1000 requests daily (which is more than enough for what I need)
const API_BASE_URL: &str = "https://api.open-meteo.com/v1/forecast";
/// The fiels we request. See <https://open-meteo.com/en/docs> for what those correspond to.
const DATA_REQUEST_FIELDS: [&str; 6] = [
    "temperature_2m",
    "relative_humidity_2m",
    "precipitation",
    "wind_speed_10m",
    "weather_code",
    "cloud_cover",
];

#[derive(Debug, Clone, Serialize, Default, PartialEq)]
pub struct Forecast {
    /// The temperature in degree celsius.
    pub temperature: f64,
    /// The relative humidity in a range of (0..100) (inclusive)
    pub relative_humidity: f64,
    /// The precipitation thickness for today in millimeters.
    pub precipitation: f64,
    /// The WMO weather status code. See [`weather_name`] and [`weather_icon`].
    pub weather_code: i32,
    /// The wind speed in km/h
    pub wind_speed: f64,
    /// The cloud coverage in percentage.
    pub cloud_coverage: f64,
    /// The region associated with the given longitude and latitude
    pub region: String,
}

#[derive(Debug, Clone, Serialize, Default, PartialEq)]
pub enum State {
    /// Fetching the weather state has failed.
    Failed,
    /// The service is currently fetching the weather state.
    #[default]
    Fetching,
    /// The weather state is ready.
    Ready(Forecast),
}

/// Raw forecast data from the open-meteo API.
#[derive(Debug, Deserialize)]
struct ForecastRaw {
    temperature_2m: f64,
    relative_humidity_2m: f64,
    precipitation: f64,
    wind_speed_10m: f64,
    weather_code: i32,
    cloud_cover: f64,
}
#[derive(Debug, Deserialize)]
struct ForecastResponse {
    current: ForecastRaw,
    timezone: String,
    latitude: f64,
    longitude: f64,
}

#[derive(Default)]
pub struct Weather {
    client: reqwest::Client,
    last_was_err: bool,
}

impl Weather {
    async fn fetch(&self) -> State {
        let Ok(res) = self
            .client
            .get(API_BASE_URL)
            .query(&[
                ("latitude", LATITUDE.to_string()),
                ("longitude", LONGITUDE.to_string()),
                ("current", DATA_REQUEST_FIELDS.join(",")),
                ("timezone", "auto".to_string()),
            ])
            .send()
            .await
            .inspect_err(|err| warn!(?err, "failed to fetch weather forecast"))
        else {
            return State::Failed;
        };

        let Ok(data) = res
            .json::<ForecastResponse>()
            .await
            .inspect_err(|err| warn!(?err, "failed to parse weather forecast"))
        else {
            return State::Failed;
        };

        info!(
            longitude = %data.longitude,
            latitude = %data.latitude,
            tz = %data.timezone,
            "Successfully fetched weather data"
        );

        State::Ready(Forecast {
            temperature: data.current.temperature_2m,
            relative_humidity: data.current.relative_humidity_2m,
            precipitation: data.current.precipitation,
            weather_code: data.current.weather_code,
            wind_speed: data.current.wind_speed_10m,
            cloud_coverage: data.current.cloud_cover,
            region: data.timezone,
        })
    }
}

impl Cacheable for Weather {
    async fn wait(&self, path: &Path) {
        if self.last_was_err {
            // Sleep less time if it was an error.
            // maybe the API was just down...? we could have gotten timed out
            sleep(Duration::from_mins(5)).await;
        }

        if let Some(elapsed) = path
            .metadata()
            .and_then(|md| md.modified())
            .ok()
            .and_then(|mtime| mtime.elapsed().ok())
        {
            // Sleep the remainder duration. Try to not update too often.
            let remaining = Duration::from_hours(24).saturating_sub(elapsed);
            info!(
                sleep_time = ?remaining,
                "Found existing weather that is new enough"
            );
            sleep(remaining).await;
            return;
        }

        // Do not sleep, update immediatly. This is either because there was no previous data
    }

    async fn update(&mut self) -> serde_json::Value {
        match self.fetch().await {
            State::Failed => {
                self.last_was_err = true;
                json!({"status": "failed", "forecast": {}})
            }
            State::Fetching => {
                self.last_was_err = false;
                json!({"status": "fetching", "forecast": {}})
            }
            State::Ready(forecast) => {
                self.last_was_err = false;
                json!({"status": "ready", "forecast": forecast})
            }
        }
    }
}
