pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.components

Scope {
    id: root

    // Bar configuration
    readonly property int barSize: 40
    readonly property int barMargin: 8
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
                top: true
                left: true
                right: true
            }
            // We make allocations on the exclusive zone ourselves to make coherant gaps
            // with the compositor's general.outer-gaps settings, while also pemitting us to
            // add a shadow on panel components.
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: root.barSize + root.barMargin
            implicitHeight: root.barSize * 2 // The actual height is here to provide space for shadows.
            color: "transparent" // modules will color themselves if needed.
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
                anchors.top: parent.top
                anchors.leftMargin: root.barMargin
                anchors.topMargin: root.barMargin
                spacing: root.barMargin

                Workspaces {
                    screen: barWindow.screen
                    size: root.barSize
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

                ClippingWrapperRectangle {
                    id: playerContainer
                    color: "transparent"
                    radius: Appearance.radius()
                    resizeChild: false

                    // NOTE: We put the shadow here instead on the actual player widget
                    // since we are clipping in in order to give the hide animation proper styling
                    layer.enabled: true
                    layer.effect: Shadow {}

                    Layout.topMargin: topMarginOffset
                    property real topMarginOffset: -200

                    function hide() {
                        // When hiding, we first slide it out before shrinking it.
                        // We still prepare the values, though.
                        // widthAnim.from = 200 + root.barSize / 1.5;
                        // widthAnim.to = 0;
                        tmAmin.from = 0;
                        tmAmin.to = -200;
                        tmAmin.restart();
                    }

                    function show() {
                        // When showing, we first grow it back to the correct size before offsetting
                        // to the correct value, again we prepare the values
                        tmAmin.to = 0;
                        tmAmin.from = -200;
                        widthAnim.to = 200 + root.barSize / 1.5;
                        widthAnim.from = 0;
                        widthAnim.restart();
                    }

                    NumberAnimation on topMarginOffset {
                        id: tmAmin
                        duration: 700
                        easing.type: Easing.InOutCubic

                        onFinished: {
                            if (to === -200) {
                                // We are hiding, so shrink the module
                                // widthAnim.restart();
                                // marginAnim.restart();
                            }
                        }
                    }

                    NumberAnimation on implicitWidth {
                        id: widthAnim
                        duration: 750
                        easing.type: Easing.InOutQuart
                        onFinished: {
                            if (from === 0)
                                tmAmin.restart();
                        }
                    }

                    Player {
                        id: player
                        size: root.barSize
                        anchors.fill: parent
                        // We animate the player sliding in and out
                        onHide: playerContainer.hide()
                        onShow: playerContainer.show()
                    }
                }

                Clock {
                    size: root.barSize
                }

                PowerButton {
                    size: root.barSize
                }
            }
        }
    }
}
