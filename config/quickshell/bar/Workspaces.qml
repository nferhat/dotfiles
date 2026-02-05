pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.components

Item {
    id: root

    // Module configuration.
    property var emptyBgPadding: 5
    required property var screen

    property var activeIdx: 1
    property var wsData: []

    function updateWsData() {
        const mon = FhtCompositor.getMonitor(screen.name);
        if (!mon)
            return;

        root.activeIdx = mon["active-workspace-idx"];
        wsData = Array.from({
            length: 9
        }, (_, idx) => {
            const wsId = mon.workspaces[idx];
            const ws = FhtCompositor.workspaces[wsId];

            // Get the active window ID inside the workspace, if any
            let activeWindowAppId = null;
            if (ws["active-window-idx"]) {
                // NOTE: The app-id can change, and to be 100% correct we would have to subscribe to
                // windowsChanged, but that would be much overkill for something that rarely happens
                // anyway
                const activeWindowId = ws.windows[ws["active-window-idx"]];
                const activeWindow = FhtCompositor.windows[activeWindowId];
                if (activeWindow)
                    activeWindowAppId = activeWindow["app-id"];
            }

            return {
                id: wsId,
                isEmpty: ws.windows.length === 0,
                activeWindowAppId
            };
        });
    }

    Component.onCompleted: root.updateWsData()
    Connections {
        target: FhtCompositor
        function onWorkspacesChanged() {
            root.updateWsData();
        }
        function onActiveWorkspaceChanged() {
            root.updateWsData();
        }
    }

    implicitWidth: container.implicitWidth
    implicitHeight: 50

    // Make it so using the scrollwheel changes the workspace.
    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y < 0)
                FhtCompositor.action({
                    "focus-next-workspace": {}
                });
            else if (event.angleDelta.y > 0)
                FhtCompositor.action({
                    "focus-previous-workspace": {}
                });
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    Rectangle {
        id: container

        anchors.fill: parent
        color: Colors.background.primary
        implicitWidth: workspaceEmptyStates.implicitWidth
        implicitHeight: workspaceEmptyStates.implicitHeight

        radius: 22
        smooth: true

        layer.enabled: true
        layer.effect: Shadow {}

        RowLayout {
            // In order to achieve the desired look, this is essentially stacked below
            // the indicator dots/icons. Giving a "connected" look when multiple adjacent
            // workspaces are not empty.
            id: workspaceEmptyStates
            anchors.fill: parent
            spacing: -2 * root.emptyBgPadding

            Repeater {
                model: root.wsData
                Rectangle {
                    id: workspaceEmptyBg
                    // Make is so the width is equal to the height
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    Layout.margins: root.emptyBgPadding

                    required property var modelData
                    required property int index

                    // Control the radii to achieve a connected look.
                    topLeftRadius: index == 0 ? 18 : (!root.wsData[index - 1].isEmpty ? 0 : 18)
                    bottomLeftRadius: workspaceEmptyBg.topLeftRadius
                    topRightRadius: index == 8 ? 18 : (!root.wsData[index + 1].isEmpty ? 0 : 18)
                    bottomRightRadius: workspaceEmptyBg.topRightRadius

                    transitions: Transition {
                        PropertyAnimation {
                            properties: "topLeftRadius,bottomLeftRadius,topRightRadius,bottomRightRadius"
                            duration: 1000
                            easing.type: Easing.Linear
                        }

                        PropertyAnimation {
                            properties: "color"
                            duration: 1000
                            easing.type: Easing.Linear
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 275
                            easing.type: Easing.Linear
                        }
                    }

                    color: Colors.ansi.color7
                    opacity: !modelData.isEmpty ? 0.1 : 0.0
                }
            }
        }

        Item {
            // A circle meant to represent the active workspace.
            id: activeWorkspaceCircleContainer
            anchors {
                fill: parent
                topMargin: 12
                bottomMargin: 12
            }

            Rectangle {
                id: activeWorkspaceCircle
                anchors.verticalCenter: parent.verticalCenter

                width: 28
                height: 28
                radius: 14

                x: root.emptyBgPadding + 5.5 + root.activeIdx * 40
                color: ColorUtils.transparentize(Colors.accent, 0.1)
                Rectangle {
                    id: activeWorkspaceCircleInner
                    anchors.fill: parent
                    anchors.margins: 10
                    radius: 100
                    color: ColorUtils.transparentize(Colors.ansi.color0, 0.5)
                }

                Behavior on x {
                    NumberAnimation {
                        duration: 265
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
                    }
                }
            }
        }

        RowLayout {
            // The workspace "icons"
            // For now, they only display a grey dot if there's nothing on the workspace and
            // you are not on the it, there's an additional icon stacked between these icons and
            // the empty state bg, used to indicate the active WS.
            //
            // FIXME: Show the icons of the active apps of ewach workspace.
            id: workspaceIcons
            spacing: -2 * root.emptyBgPadding
            anchors.fill: parent

            Repeater {
                model: root.wsData
                Item {
                    id: workspaceIcon

                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    Layout.margins: root.emptyBgPadding

                    required property var index
                    required property var modelData
                    property var workspace: FhtCompositor.workspaces

                    Rectangle {
                        anchors.centerIn: parent
                        width: 8
                        height: 8
                        radius: 8
                        color: Colors.text.primary
                        opacity: workspaceIcon.index == root.activeIdx ? 0 : 0.325

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
                            }
                        }
                    }

                    // FIXME: Ehhh, I don't really like how this is going.
                    // Image {
                    //     id: activeWindowAppIcon
                    //     visible: !modelData.isEmpty
                    //     anchors.centerIn: parent
                    //     width: 20
                    //     height: 20
                    //     source: Quickshell.iconPath(AppIconSearch.getCachedIcon(modelData.activeWindowAppId))
                    //
                    //     // No need to show it if we are focused.
                    //     opacity: workspaceIcon.index != root.activeIdx ? 1 : 0
                    //     Behavior on opacity {
                    //         NumberAnimation {
                    //             duration: 150
                    //             easing.type: Easing.BezierSpline
                    //             easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
                    //         }
                    //     }
                    // }

                    Button {
                        id: activateWorkspaceButton
                        anchors.fill: parent
                        opacity: 0
                        onReleased: FhtCompositor.action({
                            "focus-workspace": {
                                "workspace-id": modelData.id
                            }
                        })
                    }
                }
            }
        }
    }
}
