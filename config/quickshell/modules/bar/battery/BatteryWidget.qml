import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.components
import qs.components.styled
import qs.theme

Rectangle {
    id: root

    required property UPowerDevice device
    required property bool expand
    required property int closedWidth
    required property int closedHeight

    // RowLayout {
    //     id: contentLayout
    //     anchors.left: parent.left
    //     anchors.verticalCenter: parent.verticalCenter
    //     spacing: 15

    //     // The battery rectangle

    // }

    readonly property color deviceColor: {
        if (device.state === UPowerDeviceState.Charging)
            return Colors.ansi.color2;

        const percentage = device.percentage;
        if (percentage > 0.80)
            return Colors.ansi.color2;
        else if (percentage > 0.33)
            return Colors.ansi.color4;
        else if (percentage > 0.15)
            return Colors.ansi.color3;
        else
            return Colors.ansi.color1;
    }

    /// Formats a given number of seconds into a D days, H hours, M minutes and S seconds remaining.
    /// Removes the parts that are equal to zero, so giving 3661 will give you: "1 hour, 1 minute and 1 second"
    function formatSeconds(totalSeconds: int): string {
        const secondsPerMinute = 60;
        const secondsPerHour = 60 * 60;
        const secondsPerDay = 24 * 60 * 60;

        const days = Math.floor(totalSeconds / secondsPerDay);
        const hours = Math.floor((totalSeconds % secondsPerDay) / secondsPerHour);
        const minutes = Math.floor((totalSeconds % secondsPerHour) / secondsPerMinute);
        const seconds = Math.floor(totalSeconds % secondsPerMinute);

        var parts = [];

        if (days > 0)
            parts.push(days + "d");
        if (hours > 0) {
            parts.push(hours + "h");
            if (days > 0)
                return parts.join(", ");
        }
        if (minutes > 0) {
            parts.push(minutes + "m");
            if (hours > 0)
                return parts.join(" ");
        }
        if (seconds > 0 || parts.length === 0)
            parts.push(seconds + "s");

        if (parts.length === 1) {
            return parts[0];
        }

        var lastPart = parts.pop();
        return parts.join(", ") + " and " + lastPart;
    }

    width: contentLayout.width + 15
    height: contentLayout.height + 30
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    color: Colors.background.tertiary
    radius: Appearance.radius(-8)

    RowLayout {
        id: contentLayout

        anchors.left: parent.left
        spacing: 15
        anchors.verticalCenter: parent.verticalCenter

        WavyProgressBar {
            id: batteryRectangle

            readonly property color deviceColor: root.deviceColor

            implicitWidth: root.closedWidth
            implicitHeight: root.expand ? infoLayout.height : root.closedHeight
            radius: Appearance.radius(-8)
            normalColor: ColorUtils.mix(Colors.background.tertiary, deviceColor)
            filledColor: deviceColor
            percentage: root.device.percentage
            wave: root.device.state === UPowerDeviceState.Charging

            // Manual padding
            Layout.leftMargin: root.expand ? 15 : 0

            Behavior on Layout.leftMargin {
                animation: Animations.elementMove.numberAnimation(this)
            }
        }
        ColumnLayout {
            id: infoLayout

            spacing: 10

            RowLayout {
                Layout.topMargin: 15

                ColumnLayout {
                    spacing: 0

                    RowLayout {
                        spacing: 0

                        StyledText {
                            text: "Laptop Battery - "
                            font.bold: true
                            font.pixelSize: 20
                        }
                        StyledText {
                            text: (root.device.percentage * 100.0) + "%"
                            color: root.deviceColor
                        }
                    }
                    StyledText {
                        color: Colors.text.secondary
                        text: {
                            switch (root.device.state) {
                            case UPowerDeviceState.FullyCharged:
                                return "Hooray! It's fully charged";
                            case UPowerDeviceState.Unknown:
                            case UPowerDeviceState.Empty:
                                return "Empty";
                            case UPowerDeviceState.Charging:
                                return root.formatSeconds(root.device.timeToFull) + " to full";
                            case UPowerDeviceState.Discharging:
                                return "About " + root.formatSeconds(root.device.timeToEmpty) + " left";
                            default:
                                return "Unknown state";
                            }
                        }
                    }
                }
                MaterialIcon {
                    text: (root.device.percentage < 0.15) ? "battery_android_alert" : "battery_android_0"
                    size: 24
                    fill: true
                    color: (root.device.percentage < 0.15) ? Colors.ansi.color1 : Colors.ansi.color6
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
            }
            StatsList {
                Layout.fillWidth: true
                Layout.topMargin: 4
                lines: [
                    {
                        title: "State",
                        value: UPowerDeviceState.toString(root.device.state).toUpperCase().replace(" ", "_")
                    },
                    {
                        title: "Change Rate",
                        value: root.device.changeRate + "W"
                    },
                    {
                        title: "Energy",
                        value: root.device.energy + "/" + root.device.energyCapacity + "Wh"
                    },
                    {
                        title: "Health",
                        color: Colors.ansi.color1,
                        value: "UNSUPPORTED"
                    }
                // FIXME: Augh, health is not supported for my battery
                // {
                //     title: "Health",
                //     value: root.device.healthPercentage
                // }
                ]
            }
        }
    }
}
