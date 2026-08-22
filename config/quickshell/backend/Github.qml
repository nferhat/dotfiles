pragma Singleton
pragma ComponentBehavior: Bound

// Github.qml -*- github notifications watcher. Nothing fancy.
// We use a JSON adapter in order to read these.

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string path: Quickshell.env("XDG_STATE_HOME") + "/qs-backend/github-notifications.json"
    readonly property alias notifications: adapter.notifications

    FileView {
        path: root.path
        watchChanges: true

        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            property var notifications
        }
    }
}
