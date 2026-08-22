pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// Custom Pipewire/wayland screencopy capture clone. Made specifically for fht-compositor.
// Replaces the (alright but not styled) GTK one I made.

import Quickshell
import Quickshell.Widgets
import qs.components
import qs.components.styled
import qs.theme
import qs.utils

Scope {
    id: root

    property var requests: []

    function close() {
    }

    AsyncRequestHelper {
        id: requestsHandler

        ipcTarget: "share-picker"
        completedStatus: "selected"
        concurrent: true

        onRequestStarted: request => {
            // Requests get pushed on a queue. If two programs request a session too fast,
            // we need to make sure we don't throw away one of them, or both...
            root.requests = [...root.requests, request];
            loader.loading = true;
        }
    }
    LazyLoader {
        id: loader

        FullscreenPrompt {
            id: prompt

            function completed() {
                let request = root.requests.pop();
                // I am not proud of the code that is following...
                if (tabSwitcher.selectedIndex === 0) {
                    requestsHandler.resolve(request, {
                        "Output": {
                            "name": outputPicker.selectedScreen.name
                        }
                    });
                } else if (tabSwitcher.selectedIndex === 1) {
                    let window = windowPicker.selectedWindow;
                    requestsHandler.resolve(request, {
                        "Window": {
                            "id": window.id,
                            "title": window.title,
                            "app_id": window["app-id"]
                        }
                    });
                }

                this.close();
            }

            child: ClippingWrapperRectangle {
                layer.enabled: true
                color: Colors.background.primary
                radius: Appearance.radius(-4)
                anchors.centerIn: parent

                layer.effect: Shadow {
                }

                ColumnLayout {
                    ColumnLayout {
                        Layout.margins: 20
                        spacing: 20

                        TextWithSub {
                            icon: "cast"
                            text: "Screencast request"
                            subText: "org.freedesktop.portal.ScreenCast"
                            textFont.weight: 700
                        }
                        StyledText {
                            Layout.preferredWidth: 700
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: "An application has requested a PipeWire screencast session. Select what source the cast will use here."
                        }
                        TabPicker {
                            id: tabSwitcher

                            Layout.fillWidth: true
                            Layout.leftMargin: 4
                            Layout.rightMargin: 4
                            Layout.bottomMargin: -15

                            onSelectedIndexChanged: swipeView.currentIndex = selectedIndex

                            TabItem {
                                name: "Output"
                                icon: "monitor"
                            }
                            TabItem {
                                name: "Window"
                                icon: "select_window"
                            }
                            TabItem {
                                name: "Worksapce"
                                icon: "split_scene"
                            }
                        }
                        ClippingWrapperRectangle {
                            implicitHeight: 400
                            Layout.fillWidth: true
                            color: "transparent"

                            SwipeView {
                                id: swipeView

                                interactive: false // only for the animations
                                anchors.fill: parent

                                OutputPicker {
                                    id: outputPicker
                                }
                                WindowPicker {
                                    id: windowPicker

                                    // Padding is applied on all outputs, soo I resort to doing this instead.
                                    // It's not pretty, and I'm sorry for this.
                                    topMargin: 8
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
                            StyledCheckBox {
                                text: "Save this decision (enables restoring)"
                                font.pointSize: 11
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            RowLayout {
                                spacing: 5

                                MaterialIcon {
                                    text: "fullscreen_exit"
                                    Layout.topMargin: 3
                                    color: Colors.text.tertiary
                                }
                                StyledText {
                                    font.pointSize: 11
                                    color: ColorUtils.transparentize(Colors.text.primary, 0.5)
                                    mono: true
                                    text: "Cancel"
                                }
                            }
                            RowLayout {
                                spacing: 5

                                MaterialIcon {
                                    text: "keyboard_return"
                                    Layout.topMargin: 3
                                    color: Colors.text.tertiary
                                }
                                StyledText {
                                    color: ColorUtils.transparentize(Colors.text.primary, 0.5)
                                    font.pointSize: 11
                                    mono: true
                                    text: "Submit"
                                }
                                TapHandler {
                                    acceptedButtons: Qt.AllButtons

                                    onTapped: prompt.completed()
                                }
                            }
                        }
                    }
                    Item {
                        focus: true
                        visible: false

                        Keys.onEscapePressed: prompt.close()
                        Keys.onReturnPressed: prompt.completed()
                    }
                }
            }

            onClosing: {
                let request = root.requests.pop();
                requestsHandler.cancel(request);
            }
            onDoneClosing: {
                loader.active = false;
                if (root.requests.length !== 0)
                    // There are still clients that are requesting session(s)
                    // Re-open and keep going.
                    loader.activeAsync = true;
            }
        }
    }
}
