pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects

// A variant of the fullscreen prompt that doesn't get exclusive focus, doesn't darken and
// blur the background, etc... Meant for stuff like launchers.

import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.theme
import qs.utils

Scope {
    id: root

    property bool startAnim: true
    property alias child: wrapperManager.child

    // Signal sent when closing animation starts
    signal closing
    // Signal sent when closing animation is done.
    signal doneClosing

    // Start closing this fullscreen prompt.
    // Will send doneClosing() when the animations is done.
    function close() {
        startAnim = false;
        childWrapper.opacity = 0;
        window.WlrLayershell.keyboardFocus = WlrKeyboardFocus.None;
        closeTimer.start();
        closing();
    }

    Timer {
        id: closeTimer

        // I guess this is the fastest animation
        interval: Animations.elementMoveFast.duration

        onTriggered: {
            root.doneClosing();
            window.visible = false;
        }
    }

    // qmllint disable
    PanelWindow {
        id: window

        color: "transparent"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        // NOTE: +extra size for eventual shadows
        implicitHeight: root.child.height + 50
        implicitWidth: root.child.width + 50

        Item {
            id: childWrapper

            // This is adapted from fht-compositor.
            // Same feel as the window opening animations.
            readonly property real threshold: 0.97

            anchors.fill: parent
            opacity: 0
            scale: opacity * (1.0 - threshold) + threshold

            Behavior on opacity {
                animation: Animations.elementMoveEnter.numberAnimation(this)
            }

            // Fade-in effect.
            Component.onCompleted: opacity = 1

            WrapperManager {
                id: wrapperManager
            }
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                propagateComposedEvents: false
            }
        }
    }
}
