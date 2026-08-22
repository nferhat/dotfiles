pragma ComponentBehavior: Bound

/**
 * Material 3 slider. See https://m3.material.io/components/sliders/overview
 * It doesn't exactly match the spec because it does not make sense to have stuff on a computer that fucking huge.
 * Should be at 3/4 scale...
 *
 * Adapted from end-4's dotfiles. Go check them out!
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.components
import qs.components.styled
import qs.theme

Slider {
    id: root

    // Different presets from Material UI. Makes it easy to adapt to anything really.
    enum Configuration {
        Wavy = 4,
        XS = 12,
        S = 18,
        M = 30,
        L = 42,
        XL = 72
    }

    property var configuration: StyledSlider.Configuration.S

    // Dividers break up one continuous slider into different segments
    // This could be to indicate a low/middle/high, for example
    property list<real> dividerValues: []
    // The colors of each segment.
    property list<color> segmentColors: []
    // Margins between each section of the divider
    readonly property real dividerMargins: 1.5

    // The handle width. In material UI, it is supposed to change thickness when you press it. But I got rid of
    // this since it just looks funny, and on desktops we already have the precision of a mouse.
    readonly property real handleWidth: 5
    // Color of the handle.
    property color handleColor: Colors.accent
    // Margins around the change
    readonly property real handleMargins: 3

    // Color of the filled part and the handle
    property color highlightColor: handleColor
    // Color of the track (IE the non-filled part)
    property color trackColor: ColorUtils.transparentize(Colors.text.primary, 0.975)

    // stop indicators are to indicate some significant value in the slider. For example, this could be for example
    // to show off a default value or sensible values to set it to.
    property list<real> stopIndicatorValues: []
    // Color of the stop indicators. The normal color are for dots in the track (that the slider didn't reach yet),
    // the highlighted color are for the dots that have been reached.
    property color dotColor: ColorUtils.mix(handleColor, Colors.background.primary, 0.2)
    property color dotColorHighlighted: ColorUtils.mix(handleColor, Colors.background.primary, 0.8)
    // The size of the dots
    readonly property real trackDotSize: 4

    // Whether to display a tooltip with a percentage.
    property bool usePercentTooltip: true

    // Wavy is mostly for media stuff, since it looks cool.
    readonly property bool wavy: configuration === StyledSlider.Configuration.Wavy
    property bool animateWave: true
    property real waveAmplitudeMultiplier: 1

    // Now derive all the values from the configuration.
    readonly property real trackWidth: configuration
    readonly property real trackRadius: trackWidth >= StyledSlider.Configuration.XL ? 21 : trackWidth >= StyledSlider.Configuration.L ? 12 : trackWidth >= StyledSlider.Configuration.M ? 9 : trackWidth >= StyledSlider.Configuration.S ? 6 : height / 2
    readonly property real handleHeight: (configuration === StyledSlider.Configuration.Wavy) ? 24 : Math.max(33, trackWidth + 9)
    readonly property string tooltipContent: usePercentTooltip ? `${Math.round(((value - from) / (to - from)) * 100)}%` : `${Math.round(value)}`

    // To break the square edges slightly
    readonly property real unsharpenRadius: 2
    // Account for padding from the handle.
    readonly property real effectiveDraggingWidth: width - leftPadding - rightPadding

    leftPadding: handleMargins
    rightPadding: handleMargins
    Layout.fillWidth: true
    from: 0
    to: 1

    background: Item {
        id: background

        property var normalized: root.dividerValues.map(v => (v - root.from) / (root.to - root.from))
        property var filtered: normalized.filter(v => Math.abs(v - root.visualPosition) * root.effectiveDraggingWidth > root.handleMargins + root.handleWidth / 2 - root.dividerMargins)
        property var leftValues: [0, ...filtered.filter(v => v < root.visualPosition), root.visualPosition]
        property var rightValues: [root.visualPosition, ...filtered.filter(v => v > root.visualPosition), 1]
        property var leftWidths: leftValues.map((v, i, a) => a[i + 1] - v).slice(0, -1)
        property var rightWidths: rightValues.map((v, i, a) => a[i + 1] - v).slice(0, -1)

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width
        implicitHeight: root.trackWidth

        // Fill left
        Repeater {
            model: background.leftWidths.length

            Loader {
                id: loader

                required property real index
                readonly property color color: {
                    let segment = root.segmentColors[index];
                    if (segment)
                        return segment;
                    else
                        return root.highlightColor;
                }
                property real leftMargin: index > 0 ? root.dividerMargins : 0
                property real rightMargin: index < background.leftWidths.length - 1 ? root.dividerMargins : root.handleMargins

                anchors.verticalCenter: background.verticalCenter
                x: background.leftValues[index] * root.effectiveDraggingWidth + leftMargin + (index > 0 ? root.leftPadding : 0)
                width: background.leftWidths[index] * root.effectiveDraggingWidth - leftMargin - rightMargin - (index === background.leftWidths.length - 1 ? root.handleWidth / 2 : 0) + (index === 0 ? root.leftPadding : 0)
                height: root.trackWidth
                active: !root.wavy

                sourceComponent: Rectangle {
                    color: loader.color
                    topLeftRadius: loader.index === 0 ? root.trackRadius : root.unsharpenRadius
                    bottomLeftRadius: loader.index === 0 ? root.trackRadius : root.unsharpenRadius
                    topRightRadius: root.unsharpenRadius
                    bottomRightRadius: root.unsharpenRadius
                }
            }
        }

        Repeater {
            model: background.leftWidths.length

            Loader {
                id: wavyLine

                required property int index
                property real leftMargin: index > 0 ? root.dividerMargins : 0
                property real rightMargin: index < background.leftWidths.length - 1 ? root.dividerMargins : root.handleMargins

                anchors.verticalCenter: background.verticalCenter
                x: background.leftValues[index] * root.effectiveDraggingWidth + leftMargin + (index > 0 ? root.leftPadding : 0)
                width: background.leftWidths[index] * root.effectiveDraggingWidth - leftMargin - rightMargin - (index === background.leftWidths.length - 1 ? root.handleWidth / 2 : 0) + (index === 0 ? root.leftPadding : 0)
                height: root.height
                active: root.wavy

                sourceComponent: WavyLine {
                    id: wavyFill

                    amplitudeMultiplier: root.waveAmplitudeMultiplier
                    fullLength: root.width
                    color: root.highlightColor
                    width: wavyLine.width
                    height: root.trackWidth

                    Connections {
                        function onValueChanged() {
                            wavyFill.requestPaint();
                        }

                        function onHighlightColorChanged() {
                            wavyFill.requestPaint();
                        }

                        target: root
                    }

                    FrameAnimation {
                        running: root.animateWave

                        onTriggered: {
                            wavyFill.requestPaint();
                        }
                    }
                }
            }
        }

        // Fill right
        Repeater {
            model: background.rightWidths.length

            Rectangle {
                required property int index
                property real leftMargin: index > 0 ? root.dividerMargins : root.handleMargins
                property real rightMargin: index < background.rightWidths.length - 1 ? root.dividerMargins : 0

                anchors.verticalCenter: background.verticalCenter
                x: background.rightValues[index] * root.effectiveDraggingWidth + leftMargin + (index === 0 ? root.handleWidth / 2 : 0) + root.leftPadding
                width: background.rightWidths[index] * root.effectiveDraggingWidth - leftMargin - rightMargin - (index === 0 ? root.handleWidth / 2 : 0) + (index === background.rightWidths.length - 1 ? root.rightPadding : 0)
                height: root.trackWidth
                color: root.trackColor
                topRightRadius: index === background.rightWidths.length - 1 ? root.trackRadius : root.unsharpenRadius
                bottomRightRadius: index === background.rightWidths.length - 1 ? root.trackRadius : root.unsharpenRadius
                topLeftRadius: root.unsharpenRadius
                bottomLeftRadius: root.unsharpenRadius
            }
        }

        // Stop indicators
        Repeater {
            model: root.stopIndicatorValues

            TrackDot {
                required property real modelData

                value: modelData
                anchors.verticalCenter: parent?.verticalCenter
            }
        }
    }
    handle: Rectangle {
        id: handle

        implicitWidth: root.handleWidth
        implicitHeight: root.handleHeight
        x: root.leftPadding + (root.visualPosition * root.effectiveDraggingWidth) - (root.handleWidth / 2)
        anchors.verticalCenter: parent.verticalCenter
        radius: 16
        color: root.handleColor

        Behavior on implicitWidth {
            animation: Animations.elementMoveFast.numberAnimation(this)
        }

        StyledToolTip {
            show: root.pressed
            text: root.tooltipContent
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor

        onPressed: mouse => mouse.accepted = false
    }

    component TrackDot: Rectangle {
        required property real value
        property real normalizedValue: (value - root.from) / (root.to - root.from)

        anchors.verticalCenter: parent.verticalCenter
        x: root.handleMargins + (normalizedValue * root.effectiveDraggingWidth) - (root.trackDotSize / 2)
        width: normalizedValue < root.visualPosition ? root.trackDotSize : root.trackDotSize / 2
        height: normalizedValue < root.visualPosition ? root.trackDotSize : root.height * 0.33
        radius: 16
        color: normalizedValue > root.visualPosition ? root.dotColor : root.dotColorHighlighted

        Behavior on width {
            animation: Animations.elementMoveFast.numberAnimation(this)
        }
        Behavior on height {
            animation: Animations.elementMoveFast.numberAnimation(this)
        }
        Behavior on color {
            animation: Animations.elementMoveFast.colorAnimation(this)
        }
    }
}
