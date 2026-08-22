import QtQuick
import Quickshell.Widgets
import qs.theme

/// A nice way progressbar intended to be used for battery representations.
/// You can set the `wave = true` and alter
ClippingRectangle {
    id: root

    // The color of the background.
    required property color normalColor

    // The color of the filled part.
    required property color filledColor
    // A secondary color determined from the filled color. This is used to create two waves, since it
    // looks "nicer"? I don't know, I like it.
    readonly property color altFilledColor: ColorUtils.mix(filledColor, Colors.background.primary, 0.8)

    // The fill percentage.
    required property real percentage

    // Wave properties. If `wave` is set to false, the progressbar will be a simple flat line.
    // Other parameters are passed to the `Math.sin` function.
    property bool wave: false
    property real waveAmplitude: wave ? 2 : 0
    property real waveFrequency: 0.12
    property real wavePhase: 0

    // Sine wave path. Forgot from where I copied it
    // FIXME: Credit
    function sineWavePath(ctx, freq, phase, amp) {
        // Calculate from the bottom up
        var filledHeight = height * (1 - root.percentage);

        // Start at bottom-right, go to bottom-left, then up to the wave start
        ctx.moveTo(width, height);
        ctx.lineTo(0, height);
        ctx.lineTo(0, filledHeight);

        var wavePoints = 200;
        for (var i = 0; i <= wavePoints; i++) {
            var x = (width / wavePoints) * i;
            var sineWave = Math.sin((x * freq) + phase) * amp;

            ctx.lineTo(x, filledHeight + sineWave);
        }

        // Close the path back to the bottom-right
        ctx.lineTo(width, height);
    }

    color: normalColor

    Behavior on normalColor {
        animation: Animations.elementMoveFast.colorAnimation(this)
    }
    Behavior on filledColor {
        animation: Animations.elementMoveFast.colorAnimation(this)
    }
    Behavior on percentage {
        animation: Animations.elementMoveSlow.numberAnimation(this)
    }

    // Animate the wave amplitude so that it goes in/out of waving nicely when the battery
    // state goes from charging => non-charging.
    Behavior on waveAmplitude {
        animation: Animations.elementMoveFast.numberAnimation(this)
    }

    // Infinite wave phasing animation, when the amplitude is non-null, of course.
    // This will keep the waving changing.
    NumberAnimation on wavePhase {
        from: 0
        to: Math.PI * 2
        duration: 5000
        loops: Animation.Infinite
        running: root.waveAmplitude > 0
    }

    // More behaviours for dynamic state changes.
    Behavior on implicitHeight {
        animation: Animations.elementMove.numberAnimation(this)
    }
    Behavior on implicitWidth {
        animation: Animations.elementMove.numberAnimation(this)
    }

    // Redraw whenever properties change. But for the wave animation only when an waving is enabled.
    // Otherwise, we will do a lot of useless redraws for nothing, consuming battery.
    //
    // However, we need to check that the amplitude is positive, since we use it to animate.
    onWavePhaseChanged: if (waveAmplitude > 0)
        canvas.requestPaint()
    onPercentageChanged: canvas.requestPaint()
    onFilledColorChanged: canvas.requestPaint()
    onColorChanged: canvas.requestPaint()

    Canvas {
        id: canvas

        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            ctx.fillStyle = root.altFilledColor;
            ctx.beginPath();
            root.sineWavePath(ctx, root.waveFrequency * 0.9, (root.wavePhase + 2.0) * 1.75, root.waveAmplitude * 1.5);
            ctx.closePath();
            ctx.fill();

            // Draw the filled area with wave effect
            ctx.fillStyle = root.filledColor;
            ctx.beginPath();
            root.sineWavePath(ctx, root.waveFrequency, root.wavePhase, root.waveAmplitude);
            ctx.closePath();
            ctx.fill();
        }
    }
}
