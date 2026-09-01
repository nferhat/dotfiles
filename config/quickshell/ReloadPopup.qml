pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.theme

Scope {
    id: root
    property bool failed
    property string errorString

    // Connect to the Quickshell global to listen for the reload signals.
    Connections {
        target: Quickshell

        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
            root.failed = false;
            popupLoader.loading = true;
        }

        function onReloadFailed(error: string) {
            // Close any existing popup before making a new one.
            popupLoader.active = false;
            Quickshell.inhibitReloadPopup();

            root.failed = true;
            root.errorString = error;
            popupLoader.loading = true;
        }
    }

    // Keep the popup in a loader because it isn't needed most of the time
    LazyLoader {
        id: popupLoader

        PanelWindow {
            id: popup

            exclusiveZone: 0
            anchors.top: true

            implicitWidth: rect.width + 50
            implicitHeight: rect.height + 50

            WlrLayershell.namespace: "quickshell:reloadPopup"

            // color blending is a bit odd as detailed in the type reference.
            color: "transparent"

            Rectangle {
                id: rect
                anchors.centerIn: parent
                color: Colors.background.primary

                implicitHeight: layout.implicitHeight + 30

                implicitWidth: layout.implicitWidth + 20
                radius: 12

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowBlur: 1
                    shadowOpacity: 1
                    shadowColor: "black"
                }

                // Fills the whole area of the rectangle, making any clicks go to it,
                // which dismiss the popup.
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onPressed: {
                        popupLoader.active = false;
                    }

                    // makes the mouse area track mouse hovering, so the hide animation
                    // can be paused when hovering.
                    hoverEnabled: true
                }

                ColumnLayout {
                    id: layout
                    spacing: 5
                    anchors {
                        top: parent.top
                        topMargin: 10
                        horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        renderType: Text.NativeRendering
                        font.family: "Fht Mono"
                        font.pointSize: 14
                        font.bold: true
                        text: root.failed ? "Quickshell: Reload failed" : "Quickshell reloaded"
                        color: Colors.text.primary
                    }

                    Rectangle {
                        // When visible is false, it also takes up no space.
                        visible: root.errorString != ""
                        implicitWidth: errorTxt.width + 10
                        implicitHeight: errorTxt.height + 10
                        color: ColorUtils.transparentize(Colors.text.primary, 0.97)
                        radius: 5

                        Text {
                            id: errorTxt
                            anchors.centerIn: parent
                            renderType: Text.NativeRendering
                            font.family: "Fht Mono"
                            font.pointSize: 12
                            text: root.errorString
                            color: Colors.text.secondary
                        }
                    }
                }

                // A progress bar on the bottom of the screen, showing how long until the
                // popup is removed.
                Rectangle {
                    id: bar
                    z: 2
                    color: root.failed ? Colors.ansi.color1 : Colors.ansi.color2
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.margins: 10
                    height: 5
                    radius: 9999

                    PropertyAnimation {
                        id: anim
                        target: bar
                        property: "width"
                        from: rect.width - bar.anchors.margins * 2
                        to: 0
                        duration: root.failed ? 10000 : 1000
                        onFinished: popupLoader.active = false

                        // Pause the animation when the mouse is hovering over the popup,
                        // so it stays onscreen while reading. This updates reactively
                        // when the mouse moves on and off the popup.
                        paused: mouseArea.containsMouse
                    }
                }
                // Its bg
                Rectangle {
                    id: bar_bg
                    z: 1
                    color: ColorUtils.transparentize(Colors.text.primary, 0.8)
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.margins: 10
                    height: 5
                    radius: 5
                    width: rect.width - bar.anchors.margins * 2
                }

                // We could set `running: true` inside the animation, but the width of the
                // rectangle might not be calculated yet, due to the layout.
                // In the `Component.onCompleted` event handler, all of the component's
                // properties and children have been initialized.
                Component.onCompleted: anim.start()
            }
        }
    }
}
