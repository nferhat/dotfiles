pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.Pipewire
import qs.components
import qs.components.styled
import qs.theme

Item {
    id: root

    required property int componentSize
    required property Region mask

    implicitWidth: root.componentSize
    implicitHeight: root.componentSize
    clip: false
    z: (inner.expand || inner.animationsRunning) ? 9999 : 0

    PwObjectTracker {
        id: tracker

        objects: [Pipewire.defaultAudioSink]
    }
    ExpandingRect {
        id: inner

        color: Colors.background.secondary
        expand: hoverHandler.hovered || pinned
        closedWidth: root.componentSize
        closedHeight: root.componentSize
        openWidth: contentLayout.width + 20
        openHeight: contentLayout.height + 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        radius: expand ? Appearance.radius(-2) : root.componentSize

        Behavior on radius {
            animation: Animations.elementMove.numberAnimation(this)
        }

        Rectangle {
            id: content

            color: Colors.background.primaryOverlay
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            RowLayout {
                id: contentLayout

                spacing: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left

                Item {
                    implicitHeight: root.componentSize
                    implicitWidth: root.componentSize
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.rightMargin: -15
                    Layout.leftMargin: inner.expand ? 10 : 0

                    Behavior on Layout.leftMargin {
                        animation: Animations.elementMoveFast.numberAnimation(this)
                    }

                    MaterialIcon {
                        text: "speaker"
                        size: 16
                        color: Colors.text.secondary
                        anchors.centerIn: parent
                    }
                }
                Separator {
                    vert: true
                }
                ColumnLayout {
                    implicitWidth: 400
                    spacing: 15

                    SinkNode {
                        node: Pipewire.defaultAudioSink
                        Layout.minimumWidth: 400
                        Layout.maximumWidth: 400
                    }
                    Separator {
                    }
                    Repeater {
                        model: ScriptModel {
                            values: Pipewire.nodes.values.filter(node => node.isSink && node.isStream)
                        }
                        delegate: StreamNode {
                            required property PwNode modelData

                            node: modelData
                        }
                    }
                }
            }
        }
        HoverHandler {
            id: hoverHandler
        }
        TapHandler {
            acceptedButtons: Qt.RightButton

            onTapped: inner.pinned = !inner.pinned
        }
    }
    TransformWatcher {
        a: root
        b: content

        onTransformChanged: inner.updateMask(root, root.mask)
    }
}
