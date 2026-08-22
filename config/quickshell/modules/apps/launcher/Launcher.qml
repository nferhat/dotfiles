pragma ComponentBehavior: Bound
import Fhtc
import QtQuick
import QtQuick.Layouts

// A launcher meant to replace vicinae & co.

import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.components
import qs.components.styled
import qs.theme

Scope {
    id: root

    GlobalShortcut {
        appid: "quickshell"
        name: "openLauncher"
        description: "Open launcher"

        onPressed: loader.active = true
    }

    LazyLoader {
        id: loader

        Prompt {
            id: prompt

            function launch() {
                const entry = entryPicker.currentItem.modelData; // qmllint disable
                if (entry.runInTerminal) {
                    let command = ["ghostty"];

                    if (entry.workingDirectory && entry.workingDirectory.length > 0) {
                        command.push("--working-directory");
                        command.push(entry.workingDirectory);
                    }

                    console.log(JSON.stringify(command));
                    Quickshell.execDetached({
                        command: [...command, "-e", ...entry.command],
                        workingDirectory: entry.workingDirectory
                    });
                } else if (entry.execute) {
                    // Using fhtc's IPC creates a systemd scope, separates the ran process
                    // from quickshell's systemd unit (and fhtc's), and allows for OOM to only
                    // kill this process if it fucks up.
                    FhtcIpc.dispatch("run", {
                        "command": entry.command
                    });
                } else {
                    // FIXME: What should I do here? :clueless:
                }
                prompt.close();
            }

            child: ClippingWrapperRectangle {
                layer.enabled: true
                color: Colors.background.primary
                radius: Appearance.radius(-4)
                anchors.centerIn: parent

                layer.effect: Shadow {}

                ColumnLayout {
                    ColumnLayout {
                        Layout.margins: 20
                        spacing: 20

                        StyledTextInput {
                            id: searchInput

                            placeholderText: "Type an application..."

                            background: Rectangle {
                                color: "transparent"
                                implicitWidth: 800
                                implicitHeight: 50

                                Rectangle {
                                    implicitHeight: 3
                                    width: parent.width
                                    anchors.bottom: parent.bottom
                                    radius: height
                                    color: Colors.separator
                                }
                            }

                            onTextChanged: entryPicker.query = text
                            Keys.onEscapePressed: prompt.close()
                            Keys.onUpPressed: evt => {
                                entryPicker.decrementCurrentIndex();
                                evt.accepted = true;
                            }
                            Keys.onDownPressed: evt => {
                                entryPicker.incrementCurrentIndex();
                                evt.accepted = true;
                            }
                            Keys.onReturnPressed: prompt.launch()
                        }

                        DesktopEntryPicker {
                            id: entryPicker

                            clip: true
                            implicitHeight: 600
                            Layout.fillWidth: true
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

                            Item {
                                Layout.fillWidth: true
                            }

                            KeybindHint {
                                icon: "fullscreen_exit"
                                name: "Cancel"

                                TapHandler {
                                    acceptedButtons: Qt.AllButtons

                                    onTapped: prompt.close()
                                }
                            }

                            KeybindHint {
                                icon: "keyboard_return"
                                name: "Launch"

                                TapHandler {
                                    acceptedButtons: Qt.AllButtons

                                    onTapped: prompt.launch()
                                }
                            }
                        }
                    }
                }
            }

            onDoneClosing: loader.active = false
            Component.onCompleted: searchInput.forceActiveFocus()

            Item {
                focus: true
                visible: false

                Keys.onEscapePressed: prompt.close()
            }
        }
    }
}
