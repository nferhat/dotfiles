import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../config/Wallpaper.js" as Config

Item {
    id: root

    Variants {
        model: Quickshell.screens

        // qmllint disable uncreatable-type
        PanelWindow {
            id: window

            required property var modelData

            screen: modelData
            WlrLayershell.layer: WlrLayer.Background
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            Image {
                anchors.fill: parent
                mipmap: false
                antialiasing: false
                sourceSize.width: window.screen.width
                sourceSize.height: window.screen.height
                source: Qt.url(Config.path)
            }
        }
    }
}
