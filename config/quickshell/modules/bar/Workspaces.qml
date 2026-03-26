pragma ComponentBehavior: Bound

import QtQuick
import Fhtc
import QtQuick.Layouts
import qs.theme

Item {
    id: root

    required property var screen
    required property var size

    // Module configuration.
    readonly property real contentPadding: 6
    readonly property real workspaceCellSpacing: 4
    // Sizes calculated from configuration+panel
    readonly property real activeWsCellSize: 72
    readonly property real inactiveWsCellSize: 32
    // The maximum of workspaces tos show.

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

    implicitHeight: container.implicitHeight
    implicitWidth: container.implicitWidth

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

        implicitWidth: workspaceIcons.implicitWidth + (root.contentPadding * 4)
        implicitHeight: workspaceIcons.implicitHeight + (root.contentPadding * 2)
        color: ColorUtils.overlayColor(Colors.background.primary, Colors.background.tertiary, 0.25)
        Component.onCompleted: console.log(color)

        radius: Appearance.radius()
        smooth: true

        RowLayout {
            // In order to achieve the desired look, this is essentially stacked below
            // the indicator dots/icons. Giving a "connected" look when multiple adjacent
            // workspaces are not empty.
            id: workspaceIcons
            anchors.centerIn: parent
            spacing: root.workspaceCellSpacing

            Repeater {
                model: 9
                Rectangle {
                    id: workspaceEmptyBg
                    // Make is so the width is equal to the height
                    Layout.preferredHeight: 6
                    Layout.topMargin: root.contentPadding
                    Layout.bottomMargin: root.contentPadding

                    required property int index
                    property var occupied: workspaceOccupied[index]
                    property var active: index == root.activeWorkspaceIndex
                    Layout.preferredWidth: active ? root.activeWsCellSize : root.inactiveWsCellSize
                    radius: Appearance.radius()

                    Behavior on Layout.preferredWidth {
                        animation: Appearance.animations.elementMove.numberAnimation.createObject(this)
                    }

                    color: {
                        if (active)
                            return Colors.accent;
                        else
                            return ColorUtils.transparentize(Colors.ansi.color7, 0.5);
                    }
                    Behavior on color {
                        animation: Appearance.animations.elementMove.colorAnimation.createObject(this)
                    }
                }
            }
        }

        // Rectangle {
        //     z: 2
        //     visible: activeWorkspaceIndex >= 0
        //     implicitHeight: root.workspaceIndicatorSize
        //     property var radiusWithPad: Appearance.radius(-root.activeWorkspacePadding - root.workspaceIndicatorMargin)
        //     radius: radiusWithPad
        //     color: Colors.accent
        //     anchors.verticalCenter: parent.verticalCenter
        //
        //     property real idx1: root.activeWorkspaceIndex >= 0 ? root.activeWorkspaceIndex : 0
        //     property real idx2: root.activeWorkspaceIndex >= 0 ? root.activeWorkspaceIndex : 0
        //     x: Math.min(idx1, idx2) * root.workspaceCellSize + root.contentPadding + root.workspaceIndicatorMargin
        //     implicitWidth: (Math.abs(idx1 - idx2) + 1) * root.workspaceIndicatorSize
        //
        //     // To
        //     Behavior on idx1 {
        //         NumberAnimation {
        //             duration: 100
        //             easing.type: Easing.InSine
        //         }
        //     }
        //     Behavior on idx2 {
        //         NumberAnimation {
        //             duration: 300
        //             easing.type: Easing.OutSine
        //         }
        //     }
        // }
    }
}
