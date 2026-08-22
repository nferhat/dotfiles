pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import qs.components.styled
import qs.theme

Item {
    id: root

    readonly property list<ShellScreen> screens: Quickshell.screens
    // the actual picked ShellScreen object (not just an index)
    property var selectedScreen: null

    // We are going to draw each screen as a rectangle. In order todo so, we
    // need to find the scale down value to fit everythin in the 600x600 canvas.
    property real minX: Math.min(...screens.map(s => s.x))
    property real minY: Math.min(...screens.map(s => s.y))
    property real maxX: Math.max(...screens.map(s => s.x + s.width))
    property real maxY: Math.max(...screens.map(s => s.y + s.height))
    // This was copied from my old iced code
    property real totalWidth: maxX - minX
    property real totalHeight: maxY - minY
    property real scaleFactor: Math.min(width / totalWidth, height / totalHeight)

    height: 400

    Item {
        id: canvas

        width: root.totalWidth * root.scaleFactor
        height: root.totalHeight * root.scaleFactor
        anchors.centerIn: parent

        Repeater {
            model: root.screens

            delegate: Rectangle {
                id: rect

                required property ShellScreen modelData
                readonly property int selected: modelData == root.selectedScreen
                readonly property int pad: root.screens.length === 0 ? 0 : 4

                x: ((modelData.x - root.minX) * root.scaleFactor) + pad
                y: ((modelData.y - root.minY) * root.scaleFactor) + pad
                width: (rect.modelData.width * root.scaleFactor) - (2 * pad)
                height: (rect.modelData.height * root.scaleFactor) - (2 * pad)
                radius: Appearance.radius()
                color: ColorUtils.transparentize(ColorUtils.mix(Colors.background.primaryOverlay, Colors.accent, rect.selected ? 0.95 : 1), rect.selected ? 0 : 0.75)

                Behavior on color {
                    animation: Animations.elementMoveFast.colorAnimation(this)
                }

                border {
                    width: selected ? 2 : 0
                    color: Colors.accent

                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: -2

                    StyledText {
                        Layout.alignment: Qt.AlignCenter
                        font.weight: rect.selected ? 700 : 400
                        // NOTE: QtRendering allows to smoothly animate the weight
                        // property, instead of NativeRendering (which uses whatever)
                        renderType: Text.QtRendering
                        mono: true
                        text: rect.modelData.model
                        font.pointSize: 16

                        Behavior on font.weight {
                            NumberAnimation {
                                duration: 100
                            }
                        }
                    }
                    StyledText {
                        Layout.alignment: Qt.AlignCenter
                        text: rect.modelData.name
                        color: Colors.text.tertiary
                        mono: true
                        font.pointSize: 12
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: if (root.selectedScreen === rect.modelData)
                        root.selectedScreen = undefined
                    else
                        root.selectedScreen = rect.modelData
                }
            }
        }
    }
}
