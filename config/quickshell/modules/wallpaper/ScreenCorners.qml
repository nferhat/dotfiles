pragma ComponentBehavior: Bound
import QtQuick

import Quickshell
import Quickshell.Wayland
import "../../config/Wallpaper.js" as Config
import qs.theme

Item {
    id: root

    LazyLoader {
        loading: Config.screenCorners

        Variants {
            model: Quickshell.screens

            // qmllint disable uncreatable-type
            PanelWindow {
                id: wallpaper

                required property var modelData

                screen: modelData
                WlrLayershell.layer: WlrLayer.Top
                exclusionMode: ExclusionMode.Ignore
                color: "transparent"

                mask: Region {
                }

                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
                Repeater {
                    model: [RoundCorner.CornerEnum.TopLeft, RoundCorner.CornerEnum.TopRight, RoundCorner.CornerEnum.BottomLeft, RoundCorner.CornerEnum.BottomRight,]

                    RoundCorner {
                        required property var modelData

                        implicitHeight: parent.height
                        implicitWidth: parent.width
                        implicitSize: Appearance.radius(-100)
                        corner: modelData
                    }
                }
            }
        }
    }
}
