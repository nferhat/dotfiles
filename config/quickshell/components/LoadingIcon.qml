import QtQuick
import qs.components.styled
import qs.theme

Item {
    id: root

    property real size: 28

    width: size
    height: size

    RotationAnimator on rotation {
        target: mIcon
        running: root.visible
        loops: Animation.Infinite
        from: 0
        to: 360
        duration: 1000
    }

    MaterialIcon {
        id: mIcon

        text: "progress_activity"
        renderType: Text.CurveRendering
        size: root.size
        anchors.centerIn: parent
        color: Colors.accent
    }
}
