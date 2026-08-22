import QtQuick
import QtQuick.Controls
import qs.components

import qs.theme

CheckBox {
    id: root

    font.family: Appearance.fonts.regular

    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        x: 0
        y: parent.height / 2 - height / 2
        radius: 4
        color: root.checked ? Colors.accent : ColorUtils.transparentize("white", 0.975)
        border.width: 2
        border.color: root.checked ? Colors.accent : Colors.separator
        scale: root.down ? 0.95 : 1

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: 100
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }

        MaterialIcon {
            anchors.centerIn: parent
            size: 16
            text: "check"
            color: root.checked ? Colors.background.primary : Colors.text.tertiary

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }
    contentItem: StyledText {
        text: root.text
        font: root.font
        opacity: enabled ? 1.0 : 0.3
        verticalAlignment: Text.AlignVCenter
        leftPadding: root.indicator.width
    }
}
