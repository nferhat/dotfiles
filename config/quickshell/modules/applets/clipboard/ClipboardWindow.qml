pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../../../config/Bar.js" as BarConfig
import qs.components
import qs.components.controls
import qs.components.styled
import qs.services
import qs.theme
import qs.utils

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    required property var position

    // Custom handling
    signal closing
    signal doneClosing

    function close() {
        root.closing();
        opacityAnimation.from = 1;
        opacityAnimation.to = 0;
        opacityAnimation.restart();
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    implicitHeight: content.height + 20
    implicitWidth: content.width + 20
    color: "transparent"

    anchors {
        left: true
        top: true
    }

    // qmllint disable
    margins {
        left: Math.max(Math.min(position.x - width / 2, screen.width - width), 0)
        top: Math.max(Math.min(position.y - 100, screen.height - height - BarConfig.bar.size), 0)
    }
    ClippingWrapperRectangle {
        id: content

        // This is adapted from fht-compositor.
        // Same feel as the window opening animations.
        readonly property real threshold: 0.9

        anchors.centerIn: parent
        color: Colors.background.primary
        radius: Appearance.radius()
        scale: opacity * (1.0 - threshold) + threshold
        layer.enabled: true

        NumberAnimation on opacity {
            id: opacityAnimation

            from: 0
            to: 1

            // qmllint disable missing-property
            duration: Animations.elementMoveEnter.duration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Animations.elementMoveEnter.curve

            onFinished: if (to === 0)
                // This was the closing animation
                root.doneClosing()
        }
        layer.effect: Shadow {
            shadowBlur: 0.5
            shadowOpacity: parent.opacity
        }

        Component.onCompleted: {
            Clipboard.fetchListProc = true;
        }

        // Double layout to apply margins only on the part with content/password field.
        // Keep the design language consistent with the central panel and other places.
        ColumnLayout {
            ColumnLayout {
                Layout.topMargin: 20
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                spacing: 20

                StyledListView {
                    model: Clipboard.list
                    implicitHeight: 600
                    Layout.preferredWidth: 500
                    snapMode: ListView.SnapOneItem
                    selectedIndex: 0
                    focus: true

                    customDelegate: ColumnLayout {
                        id: row

                        required property int index
                        required property var modelData
                        required property bool selected
                        readonly property bool isBinary: modelData.isBinary ?? false

                        implicitWidth: 500

                        Component.onCompleted: {
                            var idx = modelData.originalIndex !== undefined ? modelData.originalIndex : index;
                            if (modelData.isBinary && modelData.previewSource === "") {
                                Clipboard.loadImagePreview(idx);
                            }
                        }

                        WrapperItem {
                            Layout.alignment: row.isBinary ? Qt.AlignCenter : Qt.AlignLeft
                        }
                        StyledText {
                            Layout.fillWidth: true
                            visible: !row.isBinary
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: row.modelData.content ?? ""
                        }
                        ColumnLayout {
                            visible: row.isBinary
                            Layout.fillWidth: true
                            spacing: 15

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 0

                                PhosphorIcon {
                                    text: ""
                                    size: 20
                                    Layout.bottomMargin: 1
                                    color: Colors.text.tertiary
                                    Layout.rightMargin: 5
                                }
                                StyledText {
                                    text: row.modelData.binaryDimensions ?? "???x???"
                                    mono: true
                                    Layout.rightMargin: 30
                                }
                                PhosphorIcon {
                                    text: ""
                                    size: 20
                                    Layout.bottomMargin: 1
                                    color: Colors.text.tertiary
                                    Layout.rightMargin: 5
                                }
                                StyledText {
                                    text: row.modelData.binaryType?.toUpperCase() ?? "Unknown"
                                    Layout.rightMargin: 30
                                    mono: true
                                }
                                PhosphorIcon {
                                    text: ""
                                    size: 20
                                    fill: true
                                    Layout.bottomMargin: 1
                                    color: Colors.text.tertiary
                                    Layout.rightMargin: 5
                                }
                                StyledText {
                                    text: row.modelData.binarySize ?? "???MB"
                                    mono: true
                                }
                            }
                            Rectangle {
                                implicitHeight: image.height
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                color: "transparent"

                                Image {
                                    id: image

                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    source: row.modelData.previewSource
                                    // Cap the displayed height at 200, but never stretch beyond natural size
                                    width: Math.min(sourceSize.width, parent.width)
                                    height: sourceSize.height * (width / sourceSize.width)
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_J) {
                            incrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_K) {
                            decrementCurrentIndex();
                            event.accepted = true;
                        }
                    }
                    Keys.onEscapePressed: root.close()
                    Keys.onReturnPressed: {
                        if (currentItem)
                            Clipboard.copyToClipboard(currentItem.modelData.id);
                        root.close();
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        visible: parent.count === 0

                        PhosphorIcon {
                            text: ""
                            color: Colors.text.tertiary
                            Layout.alignment: Qt.AlignHCenter
                            size: 64
                            fill: false
                        }
                        StyledText {
                            text: "Empty clipboard"
                            color: ColorUtils.transparentize(Colors.text.primary, 0.5)
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
            Rectangle {
                color: Colors.background.tertiary
                implicitWidth: parent.width
                implicitHeight: 55

                RowLayout {
                    id: controlsLayout

                    spacing: 20

                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 15
                        rightMargin: 15
                        verticalCenter: parent.verticalCenter
                    }
                    IconButton {
                        text: "delete_sweep"
                        size: 24
                        color: hoverHandler.hovered ? Colors.ansi.color1 : Colors.text.tertiary

                        Behavior on color {
                            animation: Animations.elementMove.colorAnimation(this)
                        }
                        background: Item {
                        }

                        onClicked: {
                            Clipboard.clearHistory();
                            root.close();
                        }

                        HoverHandler {
                            id: hoverHandler
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    KeybindHint {
                        icon: ""
                        kind: "phosphor"
                        name: "Next/Previous"
                    }
                    KeybindHint {
                        icon: "keyboard_return"
                        name: "Copy"
                    }
                }
            }
        }
    }
}
