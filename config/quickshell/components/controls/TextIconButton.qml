pragma ComponentBehavior: Bound

// Variant of IconButton without a background and a shadow
// Mostly made for the player.

import QtQuick
import QtQuick.Controls
import qs.components
import qs.theme

Button {
    id: root

    property bool fill: false
    property bool shadow: false
    property real size: 16
    property color color: Colors.accent

    implicitWidth: size
    implicitHeight: size

    background: Item {}
    contentItem: MaterialIcon {
        text: root.text
        fill: root.fill
        color: root.color
        size: root.size
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.weight: root.font.weight
        layer.enabled: root.shadow
        font.bold: true
        scale: root.pressed ? 0.95 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }
        layer.effect: Shadow {}
    }
}
