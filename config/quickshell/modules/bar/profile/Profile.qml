import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.theme

Item {
    id: root

    required property int componentSize
    required property Region mask
    readonly property int openWidth: inner.openWidth
    readonly property int openHeight: inner.openHeight
    property real yOffset: 0

    implicitWidth: root.componentSize
    implicitHeight: root.componentSize
    clip: false
    z: (inner.expand || inner.animationsRunning) ? 9999 : 0

    ExpandingRect {
        id: inner

        color: "transparent"
        expand: hoverHandler.hovered || pinned
        closedWidth: root.componentSize
        closedHeight: root.componentSize
        openWidth: content.width
        openHeight: content.height
        radius: Appearance.radius(0)
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        ClippingRectangle {
            id: content

            color: Colors.background.secondary
            implicitWidth: contentLayout.width
            implicitHeight: contentLayout.height
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            ColumnLayout {
                id: contentLayout

                anchors.left: parent.left
                anchors.bottom: parent.bottom
                spacing: 15

                Rectangle {
                    id: statsCard

                    color: Colors.background.tertiary
                    implicitWidth: statsLayout.width + 30
                    implicitHeight: statsLayout.height + 30

                    Separator {
                    }
                    ColumnLayout {
                        id: statsLayout

                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 15
                        spacing: 15

                        WeatherInfo {
                        }
                        Separator {
                        }
                        MostUsedApps {
                            Layout.fillWidth: true
                        }

                        // FIXME: The calendar is butchering rendering performance
                        // It causes of forced sync. wtf?
                        Separator {
                        }
                        GithubContributionCalendar {
                            visible: inner.expand || inner.animationsRunning
                        }
                    }
                }
                InfoCard {
                    id: greetingCard

                    componentSize: root.componentSize
                    expand: inner.expand
                    Layout.bottomMargin: inner.expand ? 15 : 0
                    Layout.leftMargin: inner.expand ? 15 : 0
                    Layout.rightMargin: inner.expand ? 15 : 0

                    Behavior on Layout.bottomMargin {
                        animation: Animations.elementMove.numberAnimation(this)
                    }
                    Behavior on Layout.leftMargin {
                        animation: Animations.elementMove.numberAnimation(this)
                    }
                    Behavior on Layout.rightMargin {
                        animation: Animations.elementMove.numberAnimation(this)
                    }

                    onPinnedChanged: inner.pinned = pinned
                }
            }
        }
        HoverHandler {
            id: hoverHandler
        }
    }
    TransformWatcher {
        a: root
        b: content

        onTransformChanged: inner.updateMask(root, root.mask)
    }
}
