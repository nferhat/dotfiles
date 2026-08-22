pragma ComponentBehavior: Bound
pragma Singleton
import QtQuick

// A clipboard picker, that is extremely similar to windows.
// That's really it.

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

// PostReloadHook???
// qmllint disable import
Singleton {
    id: root

    property bool opened: loader.active
    property var position: ({})

    function open() {
        opened = true;
        fetchPositionProcess.running = true;
        // loader.activeAsync = true; // No real need to block the UI.
    }

    function close() {
        opened = false;
        if (loader.item)
            loader.item.close(); // qmllint disable
    }

    // qmllint disable
    GlobalShortcut {
        appid: "quickshell"
        name: "openClipboard"
        description: "Toggle clipboard"

        onPressed: root.open()
    }
    Process {
        // FIXME: Persist these.
        id: fetchPositionProcess

        command: ["fht-compositor", "ipc", "-j", "cursor-position"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                root.position = JSON.parse(text);
                loader.activeAsync = true;
            }
        }
    }
    LazyLoader {
        id: loader

        ClipboardWindow {
            id: window

            position: root.position

            // Destroy the window. This makes sure that the opening animations runs
            // again succesfully.
            onDoneClosing: loader.active = false
        }
    }
}
