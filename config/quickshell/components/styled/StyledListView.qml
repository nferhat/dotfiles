pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell.Widgets
import qs.theme

ListView {
    id: root

    required property Component customDelegate
    property int selectedIndex: -1
    readonly property real itemRadius: Appearance.radius(-4)
    readonly property real selectedRadius: Appearance.radius()
    readonly property real unsharpenRadius: 4

    spacing: 3
    Layout.fillWidth: true
    reuseItems: false
    highlightFollowsCurrentItem: true
    highlightMoveDuration: 100
    highlightMoveVelocity: 1000

    // We are handling these ourselves in the delegate.
    highlight: Item {
    }

    // move: Transition {
    //     NumberAnimation {
    //         properties: "x,y"
    //         duration: 400
    //     }
    // }
    // remove: Transition {
    //     NumberAnimation {
    //         property: "opacity"
    //         from: 1
    //         to: 0
    //         duration: 400
    //     }
    //     NumberAnimation {
    //         property: "scale"
    //         from: 1
    //         to: 1.0
    //         duration: 400
    //     }
    // }

    delegate: WrapperItem {
        id: row

        required property int index
        required property var modelData
        property int selected: index === root.currentIndex

        onSelectedChanged: if (customDelegateWrapper.child)
            customDelegateWrapper.child.selected = selected

        RowLayout {
            spacing: 0

            Rectangle {
                implicitWidth: 3
                color: Colors.accent
                Layout.alignment: Qt.AlignVCenter
                implicitHeight: row.selected ? row.height * 0.5 : 0
                radius: width

                Behavior on implicitHeight {
                    animation: Animations.elementMoveEnter.numberAnimation(this)
                }
            }
            WrapperRectangle {
                implicitWidth: root.width - 3
                topLeftRadius: row.selected ? root.selectedRadius : ((row.index === 0) ? root.itemRadius : root.unsharpenRadius)
                topRightRadius: topLeftRadius
                bottomLeftRadius: row.selected ? root.selectedRadius : ((row.index === root.count - 1) ? root.itemRadius : root.unsharpenRadius)
                bottomRightRadius: bottomLeftRadius
                color: ColorUtils.transparentize(ColorUtils.mix(Colors.background.primaryOverlay, Colors.accent, row.selected ? 0.95 : 1), row.selected ? 0 : 0.5)
                margin: 15

                Behavior on topLeftRadius {
                    animation: Animations.elementMoveEnter.numberAnimation(this)
                }
                Behavior on bottomLeftRadius {
                    animation: Animations.elementMoveEnter.numberAnimation(this)
                }
                Behavior on color {
                    animation: Animations.elementMoveEnter.colorAnimation(this)
                }

                TapHandler {
                    id: tapHandler

                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton

                    onTapped: if (root.interactive)
                        root.currentIndex = (root.currentIndex === row.index) ? -1 : row.index
                }
                WrapperItem {
                    id: customDelegateWrapper

                    // I know what I'm doing. Shutup.
                    // qmllint disable
                    child: {
                        let delegate = root.customDelegate.createObject(customDelegateWrapper, {
                            index: row.index,
                            modelData: row.modelData,
                            selected: row.selected
                        });
                        return delegate;
                    }
                }
            }
        }
    }
}
