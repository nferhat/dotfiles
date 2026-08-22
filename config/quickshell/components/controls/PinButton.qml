import QtQuick
import QtQuick.Controls
import qs.components
import qs.components.styled
import qs.theme

Button {
    id: root

    property bool pinned: false
    property bool toolTipText: pinned ? "Unpin" : "Pin"

    implicitWidth: 32
    implicitHeight: 32

    background: Rectangle {
        color: ColorUtils.transparentize(Colors.text.primary, root.pinned ? 0.925 : 0.975)
        radius: Appearance.radius(-2)

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }
    contentItem: MaterialIcon {
        text: "keep"
        size: 24
        fill: false
        color: root.pinned ? Colors.accent : Colors.text.primary
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        rotation: root.pinned ? 0 : 45

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
        Behavior on rotation {
            NumberAnimation {
                easing: Easing.OutBounce
                duration: 150
            }
        }
    }

    onClicked: root.pinned = !root.pinned

    StyledToolTip {
        show: root.hovered
        tooltipText: root.pinned ? "Unpin dock" : "Pin dock"
    }
}
