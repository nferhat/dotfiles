pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.theme

Scope {
    id: root

    WlSessionLock {
        id: sessionLock

        WlSessionLockSurface {
            id: lockSurface

            color: "transparent"

            LockSurface {
                anchors.fill: parent
                screen: lockSurface.screen
                ctx: context
            }
        }
    }
    LockContext {
        id: context

        property Timer delayedUnlock: Timer {
            interval: Animations.elementMoveSlow.duration
            repeat: false

            onTriggered: sessionLock.locked = false
        }

        onUnlocked: delayedUnlock.start()
    }
    IpcHandler {
        function lock() {
            if (!sessionLock.locked)
                sessionLock.locked = true;
        }

        function unlock() {
            if (sessionLock.locked)
                sessionLock.locked = false;
        }

        target: "lock"
    }
}
