pragma ComponentBehavior: Bound

import QtQuick
import qs.theme
import qs.components

Item {
    id: root

    required property var size

    implicitWidth: size
    implicitHeight: size

    Rectangle {
        id: container

        width: content.width
        height: content.height
        anchors.fill: parent
        color: Colors.background.primary

        radius: Appearance.radius()
        smooth: true

        layer.enabled: true
        layer.effect: Shadow {}

        Text {
            id: content
            anchors.centerIn: parent
            text: ""
            font.pixelSize: 20
            font.family: "Phosphor-Bold"
            color: Colors.ansi.color3
        }
    }
}
