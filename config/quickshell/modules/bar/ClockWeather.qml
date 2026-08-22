import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.backend
import qs.components
import qs.components.styled
import qs.modules.applets
import qs.theme

TogglePanelContainer {
    id: root

    required property int componentSize
    required property var config
    required property ShellScreen screen

    function getWeatherIcon(wmoCode) {
        switch (wmoCode) {
        case 0: // Clear sky
            return "clear_day";
        case 1: // Mainly clear
        case 2: // Partly cloudy
            return "partly_cloudy_day";
        case 3: // Overcast
            return "cloud";
        case 45: // Fog
        case 48: // Depositing rime fog
            return "foggy";
        case 51: // Drizzle: Light
        case 53: // Drizzle: Moderate
        case 55: // Drizzle: Dense intensity
        case 56: // Freezing Drizzle: Light
        case 57: // Freezing Drizzle: Dense intensity
        case 61: // Rain: Slight
        case 63: // Rain: Moderate
        case 65: // Rain: Heavy intensity
        case 66: // Freezing Rain: Light
        case 67: // Freezing Rain: Heavy intensity
        case 80: // Rain showers: Slight
        case 81: // Rain showers: Moderate
        case 82: // Rain showers: Violent
            return "rainy_light";
        case 71: // Snow fall: Slight
        case 73: // Snow fall: Moderate
        case 75: // Snow fall: Heavy intensity
        case 77: // Snow grains
        case 85: // Snow showers: Slight
        case 86: // Snow showers: Heavy
            return "rainy_heavy";
        case 95: // Thunderstorm: Slight or moderate
        case 96: // Thunderstorm with slight hail
        case 99: // Thunderstorm with heavy hail
            return "thunderstorm";
        default:
            // Unknown/Fallback code
            return "question_mark";
        }
    }

    function getWeatherColor(wmoCode) {
        switch (wmoCode) {
        case 0:
            return Colors.ansi.color3;
        case 1:
        case 2:
            return Colors.ansi.color3;
        case 3:
            return ColorUtils.mix(Colors.ansi.color4, Colors.ansi.color7);
        case 45:
        case 48:
            return ColorUtils.mix(Colors.text.primary, Colors.ansi.color4);
        case 51:
        case 53:
        case 55:
        case 56:
        case 57:
            return ColorUtils.mix(Colors.text.primary, Colors.ansi.color6);
        case 61:
        case 63:
        case 65:
        case 66:
        case 67:
        case 80:
        case 81:
        case 82:
            return Colors.ansi.color4;
        case 71:
        case 73:
        case 75:
        case 77:
        case 85:
        case 86:
            return Colors.ansi.color6;
        case 95:
        case 96:
        case 99:
            return Colors.ansi.color5;
        default:
            return Colors.ansi.color1;
        }
    }

    function getWeatherName(wmoCode) {
        switch (wmoCode) {
        case 0:
            return "Clear sky";
        case 1:
            return "Mainly clear";
        case 2:
            return "Partly cloudy";
        case 3:
            return "Overcast";
        case 45:
            return "Foggy";
        case 48:
            return "Rime fog";
        case 51:
            return "Light drizzle";
        case 53:
            return "Moderate drizzle";
        case 55:
            return "Heavy drizzle";
        case 56:
            return "Light freezing drizzle";
        case 57:
            return "Heavy freezing drizzle";
        case 61:
            return "Light rain";
        case 63:
            return "Moderate rain";
        case 65:
            return "Heavy rain";
        case 66:
            return "Light freezing rain";
        case 67:
            return "Heavy freezing rain";
        case 71:
            return "Light snow";
        case 73:
            return "Moderate snow";
        case 75:
            return "Heavy snow";
        case 77:
            return "Snow grains";
        case 80:
            return "Light rain showers";
        case 81:
            return "Moderate rain showers";
        case 82:
            return "Violent rain showers";
        case 85:
            return "Light snow showers";
        case 86:
            return "Heavy snow showers";
        case 95:
            return "Thunderstorm";
        case 96:
            return "Thunderstorm with light hail";
        case 99:
            return "Thunderstorm with heavy hail";
        default:
            return "Unknown conditions";
        }
    }

    opened: Applets.central.opened
    implicitHeight: componentSize

    child: RowLayout {
        id: contentLayout

        spacing: 10
        anchors.centerIn: parent

        StyledText {
            id: clockText

            Layout.alignment: Qt.AlignCenter
            lineHeight: 0.9
            font.pointSize: 11
            color: Colors.text.secondary
            text: Qt.formatDateTime(clock.date, "hh:mm")

            SystemClock {
                id: clock

                precision: SystemClock.Minutes
            }
        }

        Separator {
            vert: true
            visible: root.config.showWeather && Weather.status === "ready"
            Layout.alignment: Qt.AlignVCenter
        }

        RowLayout {
            spacing: 5
            visible: root.config.showWeather && Weather.status === "ready"
            Layout.alignment: Qt.AlignCenter

            MaterialIcon {
                Layout.alignment: Qt.AlignCenter
                text: root.getWeatherIcon(Weather.forecast.weatherCode)
                color: root.getWeatherColor(Weather.forecast.weatherCode)
                opticalSize: 20
                size: 20
            }

            StyledText {
                text: Weather.forecast.temperature + "C"
                mono: true
                font.pointSize: 11
            }
        }
    }

    Component.onCompleted: Applets.central.anchor = root

    TapHandler {
        id: tapHandler

        onTapped: Applets.central.toggle()
    }
}
