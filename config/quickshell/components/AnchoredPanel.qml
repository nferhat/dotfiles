pragma ComponentBehavior: Bound
// AnchoredPanel.qml -*- A panel that is anchored to the center of a widget in a bar.
//
// It always animates from the bottom, with a small fade-up animation, since the bar is programmed
// to be horizontal, there's no reason to make it customizable.

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.theme

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    // The anchor to stick this panel to. Make sure that it's mapped inside the bar otherwise
    // the calculations used will just break apart.
    property Item anchor: null
    // The actual widget/item to display
    required property Item child

    // Padding for the shadow.
    readonly property int shadowPadding: 30

    // Signal sent only when the content opacity animation is fully done.
    // If you are using a LazyLoader, you can destroy/unload the panel on this signal.
    signal doneClosing

    // Starts closing the panel. Listen for the doneClosing signal for when the animation
    // is finished and you can unload/destroy the panel.
    function close() {
        opacityAnimation.from = content.opacity;
        opacityAnimation.to = 0;
        opacityAnimation.restart();
    }

    // Starts opening the panel. If it was in a closing animation, reverses it and stops
    // the closing.
    function open() {
        opacityAnimation.from = content.opacity;
        opacityAnimation.to = 1;
        opacityAnimation.restart();
    }

    color: "transparent"
    // Do not ignore the panel exclusive zone.
    WlrLayershell.exclusionMode: ExclusionMode.Normal
    WlrLayershell.exclusiveZone: 0
    // See updatePosition for padding.
    implicitHeight: content.height + shadowPadding
    implicitWidth: content.width + shadowPadding

    // Do this when the component builds since if done too early the width will be
    // equal to zero and it won't be centered...
    Component.onCompleted: anchorChanged()
    // And this is logical.
    onAnchorChanged: {
        if (!anchor)
            return;
        // Calculate the position from the anchor.
        let anchorPos = anchor.mapToGlobal(anchor.width / 2, 0);
        // Divide shadowPadding by four since we split it evenly per-side, each time.
        // qmllint disable
        margins.left = Math.min(anchorPos.x - (width / 2) + (shadowPadding / 4), screen.width - width);
    }

    // Anchoring to the left is required, since that's the only way to do absolute positioning
    // with layer-shells. Bottom anchor is self-explainatory.
    anchors {
        left: true
        bottom: true
    }

    margins {
        // qmllint disable
        // Nice-looking pop-up animation.
        bottom: (1 - content.opacity) * -20
    }

    ClippingWrapperRectangle {
        id: content

        // NOTE: Anchoring to bottom for cases when (for example, in the MediaPlayer) the widget changes
        // sizes and temporarily leaves the cursor.
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.shadowPadding / 2
        anchors.horizontalCenter: parent.horizontalCenter
        color: Colors.background.primary
        radius: Appearance.radius()
        // The child, taken from the parent.
        child: root.child
        layer.enabled: true

        // Opacity animation.
        NumberAnimation on opacity {
            id: opacityAnimation

            from: 0
            to: 1

            // qmllint disable missing-property
            duration: Animations.elementMoveEnter.duration * 2
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Animations.elementMoveEnter.curve

            onFinished: if (to === 0)
                // This was the closing animation
                root.doneClosing()
        }
        layer.effect: Shadow {}
    }
}
