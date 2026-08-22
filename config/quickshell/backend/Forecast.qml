import QtQuick

QtObject {
    // The temperature in degree celsius.
    property real temperature
    // The relative humidity in a range of (0..100) (inclusive)
    property real relativeHumidity
    // The precipitation thickness for today in millimeters.
    property real precipitation
    // The WMO weather status code. See [`weather_name`] and [`weather_icon`].
    property int weatherCode
    // The wind speed in km/h
    property real windSpeed
    // The cloud coverage in percentage.
    property real cloudCoverage
    // The region associated with the given longitude and latitude
    property string region
}
