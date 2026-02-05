pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.theme

Scope {
    id: root

    property int panelSize: 56

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData

            anchors {
                top: true
                bottom: true
                left: true
            }

            WlrLayershell.namespace: "fht.desktop.Shell.Dock"
            WlrLayershell.layer: WlrLayer.Bottom
            // Since I want to have everything lined up with 8px spacing, the actual panel should not have
            // a bottom margin, **however**, since we are making use of MultiEffects to draw shadows, it
            // must otherwise the shadow would get clipped.
            WlrLayershell.exclusionMode: ExclusionMode.Normal
            exclusiveZone: root.panelSize + 4
            implicitWidth: 70

            // implicitHeight: root.panelSize
            color: "transparent"

            AppList {
                screen: panel.screen
                anchors.verticalCenter: parent.verticalCenter
                x: 4
            }
        }
    }
}
