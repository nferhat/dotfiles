pragma ComponentBehavior: Bound

import QtQuick
import qs.theme

// A re-usable component meant to toggle on/off.
// This is to indicate that it's corresponding panel has been opened.

Rectangle {
    id: root

    // Whether the associated panel/window has been opened.
    property bool opened: false

    // The actual child.
    required property Item child

    color: ColorUtils.transparentize(Colors.background.primaryOverlay, opened ? 0 : 1)
    radius: Appearance.radius(-8)
    implicitWidth: child.width + 20
    children: [tapHandler, child, bottomPill]

    Behavior on color {
        animation: Animations.elementMoveFast.colorAnimation(this)
    }
    Behavior on radius {
        animation: Animations.elementMoveFast.numberAnimation(this)
    }

    Component.onCompleted: {
        // Make the child centered.
        child.anchors.centerIn = root;
    }

    // Bottom pill thing to make it look focused/active
    Rectangle {
        id: bottomPill

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: 3
        radius: height
        color: Colors.accent
        implicitWidth: root.opened ? parent.width * 0.33 : 0

        Behavior on implicitWidth {
            animation: Animations.elementMoveEnter.numberAnimation(this)
        }
    }
}
