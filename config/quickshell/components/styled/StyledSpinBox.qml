pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import qs.components

// A nice-looking spinbox, with buttons on the sides. Can be made editable (off by default)
// FIXME: Make one for floating-point values.

import qs.theme

SpinBox {
    id: root

    property real radius: Appearance.radius(-8)
    property real innerButtonRadius: 2
    property real baseHeight: 35

    function getOpacity(indicator) {
        if (indicator.pressed)
            return 0.9;
        else if (indicator.hovered)
            return 0.95;
        else
            return 0.975;
    }

    implicitHeight: baseHeight + 8
    editable: false
    opacity: root.enabled ? 1 : 0.4

    background: Rectangle {
        color: "transparent"
        implicitHeight: root.baseHeight
    }
    contentItem: TextField {
        anchors.left: downIndicator.right
        anchors.right: upIndicator.left
        anchors.leftMargin: 3
        anchors.rightMargin: 3
        implicitHeight: root.baseHeight
        readOnly: !root.editable
        font.family: "Fht Mono"
        color: Colors.text.primary
        selectionColor: ColorUtils.mix(Colors.accent, Colors.background.tertiary)
        selectedTextColor: ColorUtils.mix(Colors.accent, Colors.text.primary, 0.7)
        placeholderTextColor: Colors.text.tertiary
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: root.value
        placeholderText: "# of windows"

        background: Rectangle {
            color: ColorUtils.transparentize(Colors.text.primary, 0.975)
            radius: root.innerButtonRadius
            implicitWidth: 300
            implicitHeight: 50
        }
    }
    down.indicator: Rectangle {
        id: downIndicator

        implicitHeight: root.baseHeight
        implicitWidth: root.baseHeight
        topLeftRadius: root.radius
        bottomLeftRadius: root.radius
        topRightRadius: root.innerButtonRadius
        bottomRightRadius: root.innerButtonRadius
        color: ColorUtils.transparentize(Colors.text.primary, root.getOpacity(root.down))

        Behavior on color {
            animation: Animations.elementMoveFast.colorAnimation(this)
        }

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }
        MaterialIcon {
            anchors.centerIn: parent
            text: "chevron_backward"
            size: 24
            color: root.down.pressed ? Colors.accent : Colors.text.tertiary

            Behavior on color {
                animation: Animations.elementMoveFast.colorAnimation(this)
            }
        }
    }
    up.indicator: Rectangle {
        id: upIndicator

        implicitHeight: root.baseHeight
        implicitWidth: root.baseHeight
        topRightRadius: root.radius
        bottomRightRadius: root.radius
        topLeftRadius: root.innerButtonRadius
        bottomLeftRadius: root.innerButtonRadius
        color: ColorUtils.transparentize(Colors.text.primary, root.getOpacity(root.up))

        Behavior on color {
            animation: Animations.elementMoveFast.colorAnimation(this)
        }

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        MaterialIcon {
            anchors.centerIn: parent
            text: "chevron_forward"
            size: 24
            color: root.up.pressed ? Colors.accent : Colors.text.tertiary

            Behavior on color {
                animation: Animations.elementMoveFast.colorAnimation(this)
            }
        }
    }
}
