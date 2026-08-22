pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

// A fullscreened window for Polkit authentification. When it opens, it will take over the
// screen, have a blurred background, and show the prompt in the center.

import Quickshell
import Quickshell.Widgets
import qs.components
import qs.components.controls
import qs.components.styled
import qs.modules.polkit // I guess its because its a singleton?

import qs.theme

Scope {
    id: root

    function formatPolkitMessage(input: string): string {
        const pre = `<span style="font-family: monospace; color: ${Colors.accent}; font-weight: bold">`;
        const post = "</span>";
        const first = input.replace(/'([^']*)'/, `${pre}$1${post}`);
        const second = first.replace(/`([^']*)'/, `${pre}$1${post}`);
        return second;
    }

    Connections {
        function onIsActiveChanged() {
            if (Polkit.isActive) {
                loader.activeAsync = true;
            } else if (loader.active && loader.item) {
                loader.item.close(); // qmllint disable
            }
        }

        target: Polkit
    }
    LazyLoader {
        id: loader

        FullscreenPrompt {
            id: prompt

            property bool authenticating: false

            child: ClippingWrapperRectangle {
                id: authBox

                layer.enabled: true
                color: Colors.background.primary
                radius: Appearance.radius(-4)
                anchors.centerIn: parent

                layer.effect: Shadow {
                }

                Component.onCompleted: passwordInput.forceActiveFocus()

                // Double layout to apply margins only on the part with content/password field.
                // Keep the design language consistent with the central panel and other places.
                ColumnLayout {
                    ColumnLayout {
                        Layout.margins: 20
                        spacing: 20

                        TextWithSub {
                            icon: "security"
                            iconColor: Colors.ansi.color3
                            text: "Authentication Required"
                            textFont.weight: 700
                            subText: Polkit.flow?.actionId ?? ""
                        }
                        StyledText {
                            // HACK: Funny formatting, since there's no standard markup for this really.
                            text: root.formatPolkitMessage(Polkit.flow?.message ?? "")
                            textFormat: Text.RichText
                            Layout.preferredWidth: 600
                            wrapMode: Text.Wrap
                        }
                        RowLayout {
                            id: passwordBoxLayout

                            Layout.fillWidth: true
                            spacing: 5

                            StyledTextInput {
                                id: passwordInput

                                property bool hidden: true

                                padding: 10
                                echoMode: hidden ? TextInput.Password : TextInput.Normal
                                placeholderText: "Password..."
                                inputMethodHints: Qt.ImhSensitiveData
                                Layout.fillWidth: true
                                focus: true

                                Keys.onEscapePressed: prompt.close()
                                Keys.onReturnPressed: {
                                    prompt.authenticating = true;
                                    Polkit.flow.submit(text);
                                }
                            }
                            IconButton {
                                implicitWidth: height
                                Layout.alignment: Qt.AlignCenter
                                Layout.fillHeight: true
                                fill: true
                                size: 24
                                text: passwordInput.hidden ? "visibility_off" : "visibility"
                                color: passwordInput.hidden ? Colors.text.tertiary : Colors.accent

                                Behavior on color {
                                    animation: Animations.elementMoveFast.colorAnimation(this)
                                }

                                onClicked: passwordInput.hidden = !passwordInput.hidden
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
                            RowLayout {
                                readonly property bool show: prompt.authenticating

                                spacing: 10
                                opacity: show ? 1 : 0
                                visible: show

                                Behavior on opacity {
                                    animation: Animations.elementMoveFast.numberAnimation(this)
                                }

                                LoadingIcon {
                                    size: 16
                                }
                                StyledText {
                                    text: "Authenticating"
                                    color: ColorUtils.transparentize(Colors.text.primary, 0.25)
                                    font.pointSize: 11
                                }
                            }
                            RowLayout {
                                readonly property bool show: (Polkit.flow?.failed && !Polkit.flow?.isSuccessful && !prompt.authenticating) ?? false

                                spacing: 5
                                opacity: show ? 1 : 0
                                visible: show

                                Behavior on opacity {
                                    animation: Animations.elementMoveFast.numberAnimation(this)
                                }

                                MaterialIcon {
                                    text: "close_small"
                                    Layout.topMargin: 3
                                    color: Colors.ansi.color1
                                    size: 20
                                }
                                StyledText {
                                    text: "Incorrect password."
                                    color: ColorUtils.transparentize(Colors.text.primary, 0.25)
                                    font.pointSize: 11
                                }
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            KeybindHint {
                                icon: "fullscreen_exit"
                                name: "Cancel"
                            }
                            KeybindHint {
                                icon: "keyboard_return"
                                name: "Submit"
                            }
                        }
                    }
                }
            }

            onDoneClosing: {
                loader.active = false; // Only destroy the prompt once its fully transparent
                Polkit.flow?.cancelAuthenticationRequest();
            }

            Connections {
                function onIsCompletedChanged() {
                    if (Polkit.flow.isCompleted) {
                        prompt.authenticating = false;
                    }
                }

                function onFailedChanged() {
                    if (Polkit.flow.failed) {
                        prompt.authenticating = false;
                    }
                }

                function onIsCancelledChanged() {
                    if (Polkit.flow.isCancelled) {
                        prompt.authenticating = false;
                    }
                }

                target: Polkit.flow
            }
        }
    }
}
