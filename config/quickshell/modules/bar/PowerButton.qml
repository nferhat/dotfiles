pragma ComponentBehavior: Bound

import QtQuick
import qs.components.controls
import qs.theme

IconButton {
    required property int componentSize

    implicitHeight: componentSize
    implicitWidth: componentSize
    text: "power_settings_new"
    size: 22
    font.weight: 600
    color: Colors.ansi.color1

    background: Rectangle {
        id: bg

        color: Colors.background.primaryOverlay
        radius: Appearance.radius(-8)
    }
}
