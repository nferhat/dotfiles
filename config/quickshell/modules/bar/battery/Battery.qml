import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.components
import qs.theme

Item {
    id: root

    required property int componentSize
    required property Region mask
    readonly property UPowerDevice device: UPower.displayDevice

    implicitWidth: root.componentSize
    implicitHeight: inner.closedHeight
    clip: false
    z: (inner.expand || inner.animationsRunning) ? 9999 : 0

    ExpandingRect {
        id: inner

        property int bottomMarginAnim: expand ? -root.componentSize : 0

        color: "transparent"
        closedWidth: root.componentSize
        closedHeight: 50
        openWidth: content.width
        openHeight: content.height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomMarginAnim
        anchors.left: parent.left

        Behavior on bottomMarginAnim {
            animation: Animations.elementMove.numberAnimation(this)
        }

        BatteryWidget {
            id: content

            device: root.device
            expand: inner.expand
            closedWidth: inner.closedWidth
            closedHeight: inner.closedHeight
        }
        TapHandler {
            acceptedButtons: Qt.RightButton

            onTapped: inner.pinned = !inner.pinned
        }
        TapHandler {
            acceptedButtons: Qt.LeftButton

            onTapped: inner.expand = !inner.expand
        }
    }
    TransformWatcher {
        a: root
        b: content

        onTransformChanged: inner.updateMask(root, root.mask)
    }
}
