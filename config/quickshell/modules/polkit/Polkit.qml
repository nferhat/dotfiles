pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick

import Quickshell
import Quickshell.Services.Polkit

Singleton {
    id: root

    property alias isActive: polkit.isActive
    property alias isRegistered: polkit.isRegistered
    property AuthFlow flow: polkit.flow
    property alias path: polkit.path

    PolkitAgent {
        id: polkit
    }
}
