// qmllint disable

pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string path: Backend.getFilePath("weather.json")
    property alias status: adapter.status
    property Forecast forecast: Forecast {
        temperature: forecastAdapter.temperature
        relativeHumidity: forecastAdapter.relativeHumidity
        precipitation: forecastAdapter.precipitation
        weatherCode: forecastAdapter.weatherCode
        windSpeed: forecastAdapter.windSpeed
        cloudCoverage: forecastAdapter.cloudCoverage
        region: forecastAdapter.region
    }

    function update(data) {
        if (data === "Failed") {
            root.status = "failed";
        } else if (data === "Fetching") {
            root.status = "fetching";
        } else {
            let forecast = data.Ready; // qmllint disable
            root.status = "ready";
            root.forecast.temperature = forecast.temperature;
            root.forecast.relativeHumidity = forecast.relative_humidity;
            root.forecast.precipitation = forecast.precipitation;
            root.forecast.weatherCode = forecast.weather_code;
            root.forecast.windSpeed = forecast.wind_speed;
            root.forecast.cloudCoverage = forecast.cloud_coverage;
            root.forecast.region = forecast.region;
        }
    }

    FileView {
        path: root.path
        watchChanges: true

        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            property string status
            property JsonObject forecast: JsonObject {
                id: forecastAdapter

                property real temperature
                property real relativeHumidity
                property real precipitation
                property int weatherCode
                property real windSpeed
                property real cloudCoverage
                property string region

                onTemperatureChanged: root.forecast.temperature = temperature
            }
        }
    }
}
