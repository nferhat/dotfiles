pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell.Widgets
import qs.components.styled
import qs.theme

Rectangle {
    id: root

    // The index of the active tab:
    property int selectedIndex: 0
    default property list<TabItem> items: []
    // For the bottom pill
    readonly property real tabWidth: items.length === 0 ? 0 : width / items.length

    color: "transparent"
    radius: Appearance.radius(-4)
    implicitHeight: 48

    RowLayout {
        visible: root.items.length > 0
        spacing: 0
        width: parent.width
        anchors.centerIn: parent

        Repeater {
            model: root.items

            Rectangle {
                id: tab

                required property int index
                required property TabItem modelData
                readonly property bool selected: index === root.selectedIndex

                implicitHeight: root.height
                implicitWidth: root.tabWidth
                color: ColorUtils.transparentize("white", selected ? 0.99 : 1)
                radius: Appearance.radius(-4)

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton

                    onTapped: root.selectedIndex = tab.index
                }
                RowLayout {
                    spacing: 10
                    anchors.centerIn: parent

                    MaterialIcon {
                        text: tab.modelData.icon
                        visible: tab.modelData.icon !== ""
                        size: 24
                        fill: false
                        color: tab.selected ? tab.modelData.iconColor : Colors.text.tertiary

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }
                    StyledText {
                        color: ColorUtils.transparentize(Colors.text.primary, tab.selected ? 0 : 0.5)
                        mono: true
                        text: tab.modelData.name
                        font.weight: tab.selected ? 700 : 400
                        // NOTE: QtRendering allows to smoothly animate the weight
                        // property, instead of NativeRendering (which uses whatever)
                        renderType: Text.QtRendering

                        Behavior on font.weight {
                            NumberAnimation {
                                duration: 100
                            }
                        }
                    }
                }
            }
        }
    }
    Rectangle {
        readonly property int pad: Math.floor(root.tabWidth * 0.66)
        readonly property int size: root.tabWidth - pad

        // Two animated indices to create a stretchy transition effect
        property real idx1: root.selectedIndex
        property real idx2: root.selectedIndex

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        implicitWidth: Math.abs(idx1 - idx2) * size + size
        implicitHeight: 3
        x: (Math.min(idx1, idx2) * root.tabWidth) + (pad / 2)
        radius: width
        color: Colors.accent

        Behavior on idx1 {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuart
            }
        }
        Behavior on idx2 {
            NumberAnimation {
                duration: 400 / 3
                easing.type: Easing.OutQuart
            }
        }
    }
}
