pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects

// A fullscreened window for Polkit authentification. When it opens, it will take over the
// screen, have a blurred background, and show the prompt in the center.

// I am truly sorry for the fade-in effects. Sorry.

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
        darkenBg.opacity = 0;
        closeTimer.start();
        closing();
    }

    Component.onCompleted: capture.start()

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
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        Capture {
            id: capture

            namespace: "fullscreen-prompt"

            onReady: bg.source = imageFor(window.screen.name)
        }
        Image {
            id: bg

            anchors.fill: parent
            opacity: 0
            layer.enabled: true

            Behavior on opacity {
                animation: Animations.elementMoveFast.numberAnimation(this)
            }
            layer.effect: MultiEffect {
                autoPaddingEnabled: false
                blurEnabled: true
                blur: root.startAnim ? 1 : 0.0
                blurMax: 64
                blurMultiplier: 1
                contrast: root.startAnim ? 0.05 : 0
                saturation: root.startAnim ? 0.1 : 0

                Behavior on blur {
                    animation: Animations.elementMoveFast.numberAnimation(this)
                }
                Behavior on contrast {
                    animation: Animations.elementMoveFast.numberAnimation(this)
                }
                Behavior on saturation {
                    animation: Animations.elementMoveFast.numberAnimation(this)
                }
            }

            Component.onCompleted: opacity = 1

            MouseArea {
                anchors.fill: bg

                onClicked: root.close()
            }
        }
        Rectangle {
            id: darkenBg

            color: "#7f000000"
            anchors.fill: parent
            opacity: 0

            Behavior on opacity {
                animation: Animations.elementMoveFast.numberAnimation(this)
            }

            // Fade-in effect.
            Component.onCompleted: opacity = 1
        }
        Item {
            id: childWrapper

            // This is adapted from fht-compositor.
            // Same feel as the window opening animations.
            readonly property real threshold: 0.95

            anchors.fill: parent
            opacity: 0
            scale: opacity * (1.0 - threshold) + threshold

            Behavior on opacity {
                animation: Animations.elementMoveFast.numberAnimation(this)
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
