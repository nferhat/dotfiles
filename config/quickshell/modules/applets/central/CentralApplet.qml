pragma ComponentBehavior: Bound

// A central panel. It's opened from the ClockWeather widget, revealing information about
// the time, the weather, notifications, and whatever I feel like showing here.

import QtQuick
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.components
import qs.modules.applets

AppletPanel {
    id: root

    // qmllint disable uncreatable-type
    window: AnchoredPanel {
        id: window

        child: WrapperItem {
            margin: 30

            GithubNotificationList {
                implicitWidth: 600
            }
        }
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "toggleCentralPanel"
        description: "Toggle central panel"

        onPressed: root.toggle()
    }
}
