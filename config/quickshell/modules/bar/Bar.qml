pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.theme

Scope {
    id: root

    // Bar configuration
    readonly property int barSize: 52
    readonly property int barMargin: 6
    readonly property int componentSize: barSize - (2 * barMargin)
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: barWindow
            required property ShellScreen modelData
            screen: modelData

            WlrLayershell.namespace: "fht.desktop.Shell.Bar"
            WlrLayershell.layer: WlrLayer.Top
            // The panel will span across the entire top region.
            anchors {
                bottom: true
                left: true
                right: true
            }
            // We make allocations on the exclusive zone ourselves to make coherant gaps
            // with the compositor's general.outer-gaps settings, while also pemitting us to
            // add a shadow on panel components.
            exclusionMode: ExclusionMode.Auto
            implicitHeight: root.barSize // The actual height is here to provide space for shadows.
            color: ColorUtils.transparentize(Colors.background.tertiary, 0)
            // Mask to capture input on the entire window when open
            mask: Region {
                y: root.barMargin
                x: root.barMargin
                width: barWindow.screen.width - 2 * root.barMargin
                height: root.barSize
            }

            RowLayout {
                id: leftWidgets
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: root.barMargin
                spacing: root.barMargin

                Workspaces {
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignCenter
                    screen: barWindow.screen
                    size: root.componentSize
                }
            }

            RowLayout {
                id: centerWidgets
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: root.barMargin
                spacing: root.barMargin
            }

            RowLayout {
                id: rightWidgets
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: root.barMargin
                anchors.topMargin: root.barMargin
                spacing: root.barMargin

                Clock {
                    size: root.componentSize
                }
            }
        }
    }
}
