pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.theme

Scope {
    id: root

    property int panelSize: 50

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            WlrLayershell.namespace: "fht.desktop.Shell.Bar"
            WlrLayershell.layer: WlrLayer.Top
            // Since I want to have everything lined up with 8px spacing, the actual panel should not have
            // a bottom margin, **however**, since we are making use of MultiEffects to draw shadows, it
            // must otherwise the shadow would get clipped.
            WlrLayershell.exclusionMode: ExclusionMode.Normal
            exclusiveZone: 58
            implicitHeight: 62

            // implicitHeight: root.panelSize
            color: "transparent"

            RowLayout {
                id: leftWidgets
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 4
                anchors.topMargin: 4
                spacing: 8

                Workspaces {
                    Layout.fillHeight: true
                    screen: panel.screen
                }
            }

            RowLayout {
                id: centerWidgets
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 8
                spacing: 8

                Clock {
                    bar: panel
                }
            }

            RowLayout {
                id: rightWidgets
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 8
                anchors.rightMargin: 8
                spacing: 8
            }
        }
    }
}
