import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.theme

RowLayout {
    id: root
    required property bool active
    required property bool appId
    spacing: 2

    Rectangle {
        id: pillIndicator
        implicitWidth: 4
        implicitHeight: root.active ? 20 : 0
        color: active ? ColorUtils.transparentize(Colors.accent, 0.15) : Colors.text.tertiary
        radius: 2

        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuart
            }
        }
        Behavior on implicitHeight {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuart
            }
        }
        Behavior on color {
            PropertyAnimation {
                duration: 300
                easing.type: Easing.OutQuart
            }
        }
    }

    IconImage {
        implicitSize: 30
        source: Quickshell.iconPath(DesktopEntries.heuristicLookup(root.appId)?.icon)

        Button {
            anchors.fill: parent
            opacity: 0
        }
    }
}
