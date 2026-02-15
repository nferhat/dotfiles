pragma ComponentBehavior: Bound

import QtQuick
import Fhtc
import QtQuick.Layouts
import QtQuick.Controls
import qs.theme
import qs.components

Item {
    id: root

    required property var screen
    required property var size

    // Module configuration.
    property real contentPadding: 4
    property real activeWorkspacePadding: 2
    property real workspaceIndicatorMargin: 3

    // Sizes calculated from configuration+panel
    readonly property real workspaceCellSize: size - (contentPadding * 2)
    readonly property real workspaceIndicatorSize: workspaceCellSize - (workspaceIndicatorMargin * 2)

    // Data fetched from fht-compositor
    readonly property var activeWindow: FhtcWorkspaces.focusedWindow
    readonly property string screenName: screen?.name ?? ""
    // Get workspaces for this screen only, sorted by ID
    readonly property var screenWorkspaces: {
        return Object.values(FhtcWorkspaces.workspaces).filter(ws => ws.output === screenName).sort((a, b) => a.id - b.id);
    }
    // Active workspace index within this screen (0-based)
    readonly property int activeWorkspaceIndex: {
        if (!FhtcWorkspaces.activeWorkspace)
            return -1;
        return FhtcWorkspaces.activeWorkspace.id % 9;
    }

    // Workspace occupied data.
    property list<bool> workspaceOccupied: []
    function updateWorkspaceOccupied() {
        workspaceOccupied = Array.from({
            length: 9
        }, (_, i) => {
            // Get the workspace at this index for this screen
            const ws = screenWorkspaces[i];
            if (!ws)
                return false;
            // Check if the workspace has any windows
            return ws.windows && ws.windows.length > 0;
        });
    }
    Component.onCompleted: updateWorkspaceOccupied()
    Connections {
        target: FhtcWorkspaces
        function onWorkspacesChanged() {
            updateWorkspaceOccupied();
        }
        function onWindowsChanged() {
            updateWorkspaceOccupied();
        }
        function onActiveWorkspaceChanged() {
            updateWorkspaceOccupied();
        }
    }

    implicitHeight: size
    implicitWidth: 9 * workspaceCellSize + 2 * contentPadding

    // Make it so using the scrollwheel changes the workspace.
    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y < 0)
                FhtcIpc.dispatch("focus-next-workspace");
            else if (event.angleDelta.y > 0)
                FhtcIpc.dispatch("focus-previous-workspace");
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    Rectangle {
        id: container

        anchors.fill: parent
        color: Colors.background.primary

        radius: Appearance.radius()
        smooth: true

        layer.enabled: true
        layer.effect: Shadow {}

        RowLayout {
            // In order to achieve the desired look, this is essentially stacked below
            // the indicator dots/icons. Giving a "connected" look when multiple adjacent
            // workspaces are not empty.
            id: workspaceEmptyStates
            anchors.centerIn: parent
            spacing: 0

            Repeater {
                model: 9
                Rectangle {
                    id: workspaceEmptyBg
                    // Make is so the width is equal to the height
                    Layout.preferredHeight: root.workspaceCellSize
                    Layout.preferredWidth: root.workspaceCellSize
                    Layout.topMargin: root.contentPadding
                    Layout.bottomMargin: root.contentPadding

                    required property int index

                    property var occupied: workspaceOccupied[index]
                    property var leftOccupied: (workspaceOccupied[index - 1])
                    property var rightOccupied: (workspaceOccupied[index + 1])
                    property var radiusWithPad: Appearance.radius(-root.activeWorkspacePadding)
                    property var leftRadius: leftOccupied ? 0 : radiusWithPad
                    property var rightRadius: rightOccupied ? 0 : radiusWithPad

                    // Control the radii to achieve a connected look.
                    topLeftRadius: leftRadius
                    bottomLeftRadius: leftRadius
                    topRightRadius: rightRadius
                    bottomRightRadius: rightRadius

                    Behavior on topLeftRadius {
                        animation: Appearance.animations.elementMove.numberAnimation.createObject(this)
                    }
                    Behavior on topRightRadius {
                        animation: Appearance.animations.elementMove.numberAnimation.createObject(this)
                    }

                    Behavior on bottomLeftRadius {
                        animation: Appearance.animations.elementMove.numberAnimation.createObject(this)
                    }
                    Behavior on bottomRightRadius {
                        animation: Appearance.animations.elementMove.numberAnimation.createObject(this)
                    }

                    opacity: occupied ? 0.1 : 0.0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 50
                            easing.type: Easing.Linear
                        }
                    }

                    color: Colors.ansi.color7
                }
            }
        }

        Rectangle {
            z: 2
            visible: activeWorkspaceIndex >= 0
            implicitHeight: root.workspaceIndicatorSize
            property var radiusWithPad: Appearance.radius(-root.activeWorkspacePadding - root.workspaceIndicatorMargin)
            radius: radiusWithPad
            color: Colors.accent
            anchors.verticalCenter: parent.verticalCenter

            property real idx1: root.activeWorkspaceIndex >= 0 ? root.activeWorkspaceIndex : 0
            property real idx2: root.activeWorkspaceIndex >= 0 ? root.activeWorkspaceIndex : 0
            x: Math.min(idx1, idx2) * root.workspaceCellSize + root.contentPadding + root.workspaceIndicatorMargin
            implicitWidth: (Math.abs(idx1 - idx2) + 1) * root.workspaceIndicatorSize

            // To
            Behavior on idx1 {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InSine
                }
            }
            Behavior on idx2 {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutSine
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
            anchors.centerIn: parent
            spacing: 0

            implicitHeight: size
            implicitWidth: 9 * workspaceCellSize + 2 * contentPadding

            Repeater {
                model: 9

                Item {
                    required property var index
                    width: root.workspaceCellSize
                    height: root.workspaceCellSize

                    Rectangle {
                        anchors.centerIn: parent
                        implicitWidth: 8
                        implicitHeight: 8
                        radius: 8
                        color: Colors.text.secondary
                        opacity: index == root.activeWorkspaceIndex ? 0 : 0.325

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
                            }
                        }

                        Button {
                            id: activateWorkspaceButton
                            anchors.fill: parent
                            opacity: 0
                            onReleased: FhtCompositor.dispatch("focus-workspace", {
                                "workspace-id": modelData.id
                            })
                        }
                    }
                }
            }
        }
    }
}
