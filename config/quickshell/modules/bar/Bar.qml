pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import "../../config/Bar.js" as Config
import qs.components
import qs.theme

Scope {
    id: root

    readonly property int size: Config.bar.size
    readonly property int margin: Config.bar.margin
    readonly property int spacing: Config.bar.spacing
    readonly property int componentSize: size - (2 * margin)

    Variants {
        model: Quickshell.screens

        // qmllint disable uncreatable-type
        PanelWindow {
            id: window

            required property ShellScreen modelData

            screen: modelData
            WlrLayershell.namespace: "bar"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            implicitWidth: screen.width
            color: "transparent"
            // To make the shadow actually work, we need to add a +20, and set the
            // exclusive zone manually.
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: root.size
            implicitHeight: root.size + 20

            // This also forces us to put a proper mask in order to not block clicks from
            // windows, and only intercept them if they are in the bar rectangle.
            mask: Region {
                id: barMask

                width: window.screen.width
                height: root.size
                x: 0
                y: height
            }

            // The panel will span across the entire top region.
            anchors {
                right: true
                left: true
                bottom: true
            }

            Rectangle {
                id: container

                implicitWidth: window.width
                implicitHeight: root.size
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Appearance.radius(-6)
                anchors.bottom: parent.bottom
                color: Colors.background.primary
                layer.enabled: true

                layer.effect: Shadow {}

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    anchors.left: parent.left
                    anchors.leftMargin: root.margin
                    anchors.verticalCenter: parent.verticalCenter

                    Workspaces {
                        // Dunno why but workspaces look nicer when slightly smaller
                        componentSize: root.componentSize
                        config: Config.workspaces
                        Layout.topMargin: 1
                        Layout.alignment: Qt.AlignVCenter
                        screen: window.screen
                    }

                    Player {
                        id: player

                        config: Config.player
                        componentSize: root.componentSize
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    anchors.centerIn: parent

                    ClockWeather {
                        componentSize: root.componentSize
                        config: Config.clock
                        screen: window.screen
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: root.spacing
                    anchors.right: parent.right
                    anchors.rightMargin: root.margin
                    anchors.verticalCenter: parent.verticalCenter

                    PowerButton {
                        componentSize: root.componentSize
                    }
                }

                // VolumeControl {
                //     id: volumeControl
                //     mask: volumeControlRegion
                //     componentSize: root.componentSize
                //     anchors.top: bottomSep.bottom
                //     anchors.left: parent.left
                //     anchors.topMargin: root.spacing
                //     anchors.leftMargin: root.margin
                // }

                // Battery {
                //     id: batteryWidget
                //     mask: batteryRegion
                //     visible: device.isLaptopBattery && device.ready
                //     componentSize: root.componentSize - 6

                //     anchors.left: parent.left
                //     anchors.bottom: profile.top
                //     anchors.bottomMargin: root.margin
                //     anchors.leftMargin: root.margin + 3
                // }

            }
        }
    }
}
