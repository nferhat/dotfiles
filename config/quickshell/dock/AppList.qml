pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.components

// FIXME: Transitions when changing workspaces.
Item {
    id: root

    // To fetch data about the workspaces.
    required property var screen

    property var windowData: []
    property bool pinned: false
    // FIXME: Group windows with same/similar app-ids into a single "window group", their indicator
    // pill will then be split by the number of that "window group"
    function updateWindowData() {
        const mon = FhtCompositor.getMonitor("DP-3");
        if (!mon)
            return;

        const activeIdx = mon["active-workspace-idx"];
        const wsId = mon.workspaces[activeIdx];
        const ws = FhtCompositor.workspaces[wsId];
        const activeWinIdx = ws["active-window-idx"];
        if (ws.windows.length === 0 || activeWinIdx === null)
            return;

        windowData = ws.windows.map((winId, idx) => {
            const win = FhtCompositor.windows[winId];
            return {
                id: winId,
                appId: win ? win["app-id"] : null,
                active: idx == activeWinIdx
            };
        });
    }
    Component.onCompleted: root.updateWindowData()
    Connections {
        target: FhtCompositor
        function onWorkspacesChanged() {
            root.updateWindowData();
        }
        function onActiveWorkspaceChanged() {
            root.updateWindowData();
        // FIXME: To make a pretty effect, we first "hide" the dock, update it in the background,
        // and then show-it again with the updated window data.
        }
    }

    implicitWidth: 56
    implicitHeight: appListBg.implicitHeight

    // make it so using the scrollwheel changes the focused window.
    // FIXME: I should probably add a "warp-cursor" parameter to actions since it makes using them
    // impossible like this.
    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y < 0)
                FhtCompositor.action({
                    "focus-next-window": {
                        "workspace-id": {}
                    }
                });
            else if (event.angleDelta.y > 0)
                FhtCompositor.action({
                    "focus-previous-window": {
                        "workspace-id": {}
                    }
                });
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    Rectangle {
        id: appListBg

        anchors.fill: parent
        color: Colors.background.primary
        implicitWidth: iconListWrapper.implicitWidth
        implicitHeight: iconListWrapper.implicitHeight
        radius: 20
        smooth: true

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuart
            }
        }

        layer.enabled: true
        layer.effect: Shadow {}

        // WrapperItem
    }

    WrapperItem {
        id: iconListWrapper
        anchors.horizontalCenter: parent.horizontalCenter
        topMargin: 8
        bottomMargin: 16

        ColumnLayout {
            id: dockLayoutVertical
            spacing: 4
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: searchIconButton
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 38
                implicitHeight: 38

                background: Rectangle {
                    color: root.pinned ? ColorUtils.transparentize(Colors.text.primary, 0.85) : "transparent"
                    radius: 14
                }

                contentItem: Text {
                    id: searchIcon
                    font.family: "Phosphor-Bold"
                    font.pointSize: 16
                    text: ""
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    // Make the button rotate/color change when toggling pin status.
                    color: root.pinned ? Colors.accent : Colors.text.tertiary
                    rotation: root.pinned ? 0 : 45

                    Behavior on rotation {
                        enabled: Config.animDuration > 0
                        NumberAnimation {
                            duration: Config.animDuration / 2
                        }
                    }

                    Behavior on color {
                        enabled: Config.animDuration > 0
                        ColorAnimation {
                            duration: Config.animDuration / 2
                        }
                    }
                }
            }

            // Separator
            WrapperItem {
                Layout.alignment: Qt.AlignHCenter
                bottomMargin: 8
                Rectangle {
                    property bool vert: false

                    color: Colors.overBackground
                    opacity: 0.1
                    radius: 2

                    implicitWidth: 28
                    implicitHeight: 2
                }
            }

            Repeater {
                model: ScriptModel {
                    objectProp: "id"
                    values: root.windowData
                }

                AppIcon {
                    required property var modelData
                    appId: modelData.appId
                    active: modelData.active
                }
            }
        }
    }
}
