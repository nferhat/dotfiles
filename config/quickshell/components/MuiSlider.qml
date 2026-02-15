import QtQuick
import QtQuick.Controls

Slider {
    id: root

    required property color activeColor
    required property color inactiveColor
    readonly property bool isHovered: hoverHandler.hovered
    property color handleColor: "white"
    property int gap: 3

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
    }

    // The actual height to be used,
    // We smoothly transition from a "small" slider to an expanded one when hovered.
    property int barHeight: hoverHandler.hovered ? 18 : 4
    Behavior on barHeight {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
    HoverHandler {
        id: hoverHandler
        blocking: false
        onHoveredChanged: console.log("hover")
    }

    snapMode: Slider.NoSnap

    background: Item {
        id: bg

        readonly property real trackStartX: 0
        readonly property real trackEndX: width
        readonly property real trackWidth: trackEndX - trackStartX

        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: root.availableWidth
        height: 25

        Canvas {
            id: canvas

            anchors.fill: parent
            antialiasing: true
            onPaint: {
                // A custom path for the following two reasons:
                // 1. Using a ctx.roundedRect() yields weird rounded corners, more like an ellipse
                // 2. I need control on individual corners
                function drawRoundRect(ctx, x, y, w, h, rtl, rtr, rbr, rbl) {
                    ctx.beginPath();

                    ctx.moveTo(x + rtl, y);

                    ctx.lineTo(x + w - rtr, y);
                    ctx.quadraticCurveTo(x + w, y, x + w, y + rtr);

                    ctx.lineTo(x + w, y + h - rbr);
                    ctx.quadraticCurveTo(x + w, y + h, x + w - rbr, y + h);

                    ctx.lineTo(x + rbl, y + h);
                    ctx.quadraticCurveTo(x, y + h, x, y + h - rbl);

                    ctx.lineTo(x, y + rtl);
                    ctx.quadraticCurveTo(x, y, x + rtl, y);

                    ctx.closePath();
                }

                let position = root.visualPosition;
                if (position < 0.05)
                    position = 0;

                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                const radius = root.barHeight / 2;
                const y = (height - root.barHeight) / 2;

                // The actual width removes the handle and gap
                let w1 = (position * width) - root.gap - 4;
                if (root.visualPosition < 0.99)
                    w1 -= root.gap / 2;

                drawRoundRect(ctx, 0, y, w1 + 2, root.barHeight, radius, 2, 2, radius);
                ctx.fillStyle = root.activeColor;
                ctx.fill();

                // Then draw the handle
                if (position === 0) {
                    drawRoundRect(ctx, 0, 0, 4, height, 2, 2, 2, 2);
                } else {
                    drawRoundRect(ctx, w1 + root.gap + 2, 0, 4, height, 2, 2, 2, 2);
                }
                ctx.fillStyle = root.handleColor;
                ctx.fill();

                if (root.visualPosition < 0.99) {
                    // Draw after handle+gap
                    const x2 = w1 + 2 * root.gap + 6;
                    const w2 = (1 - position) * width;

                    ctx.beginPath();
                    // height/2 since we want it to be centered, for when we gotta expand.
                    drawRoundRect(ctx, x2, y, w2 - 6, root.barHeight, 2, radius, radius, 2);
                    ctx.fillStyle = root.inactiveColor;
                    ctx.fill();
                }
            }
            Connections {
                target: root
                function onVisualPositionChanged() {
                    canvas.requestPaint();
                }
                function onBarHeightChanged() {
                    canvas.requestPaint();
                }
            }
        }
    }

    handle: Rectangle {
        id: handleRect
        opacity: 0
    }
}
