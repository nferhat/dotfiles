pragma ComponentBehavior: Bound

// CornerThingy mk2 by SealEgg.
// Adds inverted corners where you need to.

import QtQuick
import QtQuick.Shapes

Item {
    id: root

    // The height/size of each corner.
    property int radius: 30

    // Whether to add a shadow to each corner.
    property bool shadow: false
    // The color of the corner.
    property color color: "#000000"
    // The corners to add.
    property var corners: [0] // 0 is top right, 1 is top left, 2 is bottom left, 3 is bottom right

    Repeater {
        model: root.corners

        delegate: Shape {
            id: invertedShape

            required property int modelData
            property int currentCorner: modelData

            asynchronous: true
            preferredRendererType: Shape.CurveRenderer
            width: root.radius
            height: root.radius
            anchors.right: currentCorner === 0 || currentCorner === 3 ? root.right : undefined
            anchors.left: currentCorner === 1 || currentCorner === 2 ? root.left : undefined
            anchors.top: currentCorner <= 1 ? root.top : undefined
            anchors.bottom: currentCorner > 1 ? root.bottom : undefined
            layer.enabled: root.shadow

            layer.effect: Shadow {
            }
            transform: Rotation {
                origin.x: root.radius / 2
                origin.y: root.radius / 2
                angle: invertedShape.currentCorner * -90
            }

            ShapePath {
                startX: 0
                startY: 0
                strokeWidth: 0
                fillColor: root.color

                PathArc {
                    x: root.radius
                    y: root.radius
                    radiusX: root.radius
                    radiusY: root.radius
                }
                PathLine {
                    x: root.radius
                    y: 0
                }
            }
        }
    }
}
