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
    property color backgroundColor: ColorUtils.transparentize(Colors.text.primary, 0.98)

    implicitWidth: 36
    implicitHeight: 36

    background: Rectangle {
        id: bg

        color: root.backgroundColor
        radius: Appearance.radius(-2)
        scale: root.pressed ? 0.95 : 1.0

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }
    }
    contentItem: MaterialIcon {
        text: root.text
        fill: root.fill
        color: root.color
        size: root.size
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.weight: root.font.weight
        layer.enabled: root.shadow
        scale: root.pressed ? 0.95 : 1.0

        layer.effect: Shadow {
        }
        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }
    }
}
