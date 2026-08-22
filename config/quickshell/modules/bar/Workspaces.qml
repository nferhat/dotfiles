pragma ComponentBehavior: Bound
import Fhtc
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Widgets
import qs.components.styled
import qs.theme
import qs.utils

Rectangle {
    id: root

    required property int componentSize
    required property ShellScreen screen
    // FIXME: Type this.
    required property var config

    // Add some slight padding around the actual indicators.
    readonly property int workspaceItemMargin: config.margin
    readonly property int workspaceItemSize: componentSize - (workspaceItemMargin * 2)

    // First fetch the workspaces that are on this output.
    // We are assured that workspaces are ordered with their IDs, since they get assigned
    // when the output gets created.
    readonly property var workspaces: {
        return Object.values(FhtcWorkspaces.workspaces).filter(ws => ws.output === screen.name).sort((a, b) => a.id - b.id);
    }
    // The active workspace index. Needs some javascript to find the correct ID position
    // among those (sorted) workspaces
    readonly property int activeWorkspaceIndex: {
        if (!FhtcWorkspaces.activeWorkspace)
            return -1;
        if (FhtcWorkspaces.activeWorkspace.output !== screen.name)
            return -1;
        // Find the index of the active workspace in our sorted screen workspaces
        const idx = workspaces.findIndex(ws => ws.id === FhtcWorkspaces.activeWorkspace.id);
        return idx;
    }
    // Occupied workspaces. Need to compute this outside of a repeater otherwise it doesn't work
    // (it recreates the widgets)
    property var workspaceOccupied: []

    // Manually update this
    function updateWorkspaceOccupied() {
        workspaceOccupied = Array.from({
            length: 9
        }, (_, i) => {
            // Get the workspace at this index for this screen
            const ws = workspaces[i];
            if (!ws)
                return false;
            // Check if the workspace has any windows
            return ws.windows && ws.windows.length > 0;
        });
    }

    implicitHeight: componentSize
    implicitWidth: (9 * workspaceItemSize) + 6
    radius: Appearance.radius(-6)
    color: Colors.background.primaryOverlay

    Connections {
        function onWorkspacesChanged() {
            updateWorkspaceOccupied();
        }

        function onWindowsChanged() {
            updateWorkspaceOccupied();
        }

        function onActiveWorkspaceChanged() {
            updateWorkspaceOccupied();
        }

        target: FhtcWorkspaces
    }

    RowLayout {
        spacing: 0
        anchors.centerIn: parent

        Repeater {
            model: 9

            delegate: Rectangle {
                required property int index
                property bool hasWindows: root.workspaceOccupied[index] ?? false
                property bool prevHasWindows: root.workspaceOccupied[index - 1] ?? false
                property bool nextHasWindows: root.workspaceOccupied[index + 1] ?? false
                property int leftRadius: prevHasWindows ? 0 : Appearance.radius(-8)
                property int rightRadius: nextHasWindows ? 0 : Appearance.radius(-8)

                color: hasWindows ? ColorUtils.transparentize(Colors.text.primary, 0.9) : "transparent"
                topLeftRadius: leftRadius
                bottomLeftRadius: leftRadius
                bottomRightRadius: rightRadius
                topRightRadius: rightRadius
                implicitHeight: root.workspaceItemSize
                implicitWidth: root.workspaceItemSize

                NumberAnimation on leftRadius {
                    duration: 300
                    easing: Easing.OutCubic
                }
                NumberAnimation on rightRadius {
                    duration: 300
                    easing: Easing.OutCubic
                }

                StyledText {
                    anchors.centerIn: parent
                    visible: root.config.showWorkspaceNumbers
                    color: ColorUtils.transparentize(Colors.text.primary, 0.8)
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 10
                    mono: true
                    text: parent.index + 1
                }

                Rectangle {
                    anchors.centerIn: parent
                    visible: !root.config.showWorkspaceNumbers
                    implicitWidth: 4
                    implicitHeight: 4
                    radius: height
                    color: ColorUtils.transparentize(Colors.text.primary, 0.8)
                }
            }
        }
    }

    RowLayout {
        spacing: 0
        anchors.centerIn: parent

        Repeater {
            model: root.workspaces

            delegate: Item {
                id: delegate

                required property int index
                required property var modelData
                readonly property var ws: modelData

                // We also display a nice app icon on workspaces that have any apps/windows open
                // So that  when switching, you know *what* you are switching to.
                readonly property int activeWindowId: {
                    if (!ws.windows)
                        return -1;
                    if (ws.windows.count === 0)
                        return -1;
                    let idx = ws["active-window-idx"];
                    if (idx === null)
                        return -1;
                    return ws.windows[idx];
                }
                readonly property string wsAppId: {
                    if (activeWindowId === -1)
                        return "";
                    let window = FhtcWorkspaces.windows[activeWindowId];
                    if (!window)
                        return "";
                    return window["app-id"];
                }
                readonly property string wsAppTitle: {
                    if (activeWindowId === -1)
                        return "";
                    let window = FhtcWorkspaces.windows[activeWindowId];
                    if (!window)
                        return "";
                    return window.title;
                }

                implicitHeight: root.workspaceItemSize
                implicitWidth: root.workspaceItemSize

                // Try to fetch the icon
                IconImage {
                    id: appIcon

                    source: {
                        let fromAppId = AppIconUtils.guessIcon(delegate.wsAppId);
                        if (fromAppId !== null)
                            return Quickshell.iconPath(fromAppId);
                        visible = false;
                        return "";
                    }
                    visible: root.config.icons.show && delegate.wsAppId !== "" && source.toString().length !== null
                    implicitWidth: height
                    implicitHeight: root.config.icons.size
                    anchors.centerIn: parent
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton

                    onTapped: FhtcIpc.dispatch("focus-workspace", {
                        "workspace-id": parent.ws.id
                    })
                }
            }
        }
    }

    Rectangle {
        readonly property int pad: Math.floor(root.workspaceItemSize * (1 - root.config.activePill.width))
        readonly property int size: root.workspaceItemSize - pad

        // Two animated indices to create a stretchy transition effect
        property real idx1: root.activeWorkspaceIndex
        property real idx2: root.activeWorkspaceIndex

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        implicitWidth: Math.abs(idx1 - idx2) * size + size
        implicitHeight: root.config.activePill.height
        x: (Math.min(idx1, idx2) * root.workspaceItemSize) + (pad / 2) + root.workspaceItemMargin / 2 + 1
        radius: width
        color: Colors.accent

        Behavior on idx1 {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuart
            }
        }
        Behavior on idx2 {
            NumberAnimation {
                duration: 400 / 3
                easing.type: Easing.OutQuart
            }
        }
    }
}
