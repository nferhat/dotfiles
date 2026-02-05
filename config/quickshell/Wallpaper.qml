pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import qs.theme

Item {
    id: root

    property var wallpaperPath: "assets/04-ambxst-blobs-blue.png"

    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: wallpaper
            required property var modelData
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            WlrLayershell.layer: WlrLayer.Background
            exclusionMode: ExclusionMode.Ignore

            Rectangle {
                radius: 0
                anchors.fill: parent
                color: "black"
            }

            ClippingRectangle {
                radius: 24
                anchors.fill: parent
                Image {
                    anchors.fill: parent
                    source: Qt.url(root.wallpaperPath)
                }
            }
        }
    }
}
