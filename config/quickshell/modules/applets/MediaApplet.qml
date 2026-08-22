pragma ComponentBehavior: Bound

// A media panel. Shows track info, seek bar and some controls.
// Looks like amberol, XD

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.components
import qs.components.controls
import qs.components.styled
import qs.modules.applets
import qs.services
import qs.theme

AppletPanel {
    id: root

    // Colors calculated using the color quantizer
    readonly property color disabledButtonColor: ColorUtils.transparentize(Colors.text.primary, 0.5)

    // qmllint disable uncreatable-type
    window: AnchoredPanel {
        id: window

        // FIXME: Use trackedPlayer and allow switching which player we are modifying.
        readonly property MprisPlayer player: MprisService.activePlayer
        // The track cover art is shown as a preview but also drives the colors of the controls/seekbar
        // Quickshell's ColorQuantizer is pretty nice, however it can't load images from the net.
        //
        // (fix soon?)
        property string trackArtUrl: player?.trackArtUrl || ""
        property bool hasTrackArt: trackArtUrl && trackArtUrl !== ""

        // Formats given seconds into a (HH:)MM:SS, for player timestamps.
        function formatTime(seconds) {
            if (isNaN(seconds) || seconds < 0) {
                seconds = 0;
            }

            var totalSeconds = Math.floor(seconds);
            var hours = Math.floor(totalSeconds / 3600);
            var minutes = Math.floor((totalSeconds % 3600) / 60);
            var secs = totalSeconds % 60;

            function pad(n) {
                return (n < 10 ? "0" : "") + n;
            }

            if (hours > 0) {
                return pad(hours) + ":" + pad(minutes) + ":" + pad(secs);
            } else {
                return pad(minutes) + ":" + pad(secs);
            }
        }

        child: Item {
            id: content

            // For the crossfade
            property bool showingA: true

            function crossfade(newSource) {
                if (showingA) {
                    bgAlt.source = newSource;
                    bg.opacity = 0;
                } else {
                    bg.source = newSource;
                    bg.opacity = 1;
                }
                showingA = !showingA;
            }

            implicitWidth: contentLayout.width + 50
            implicitHeight: contentLayout.height + 50
            layer.enabled: true

            Image {
                id: bg

                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                opacity: 1
                layer.enabled: true

                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.OutQuad
                    }
                }
                layer.effect: Blur {
                    brightness: -colorQuantizer.averageBrightness / 2
                }
            }

            Image {
                id: bgAlt

                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                opacity: Math.min((1 - bg.opacity) * 2, 1)
                layer.enabled: true

                layer.effect: Blur {
                    brightness: -colorQuantizer.averageBrightness / 2
                }
            }

            Rectangle {
                color: "#1f000000"
                anchors.fill: parent
            }

            ColumnLayout {
                id: contentLayout

                anchors.centerIn: parent
                spacing: 25

                ClippingRectangle {
                    Layout.alignment: Qt.AlignCenter
                    implicitWidth: 350
                    implicitHeight: width
                    radius: Appearance.radius(-2)
                    layer.enabled: true
                    color: "transparent"

                    layer.effect: Shadow {
                        shadowOpacity: 0.5
                    }

                    Image {
                        anchors.fill: parent
                        source: bg.source
                        opacity: bg.opacity
                        fillMode: Image.PreserveAspectCrop
                    }

                    Image {
                        anchors.fill: parent
                        source: bgAlt.source
                        opacity: bgAlt.opacity
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.preferredWidth: 350
                    spacing: 0

                    StyledText {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        font.bold: true
                        font.pointSize: 13
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        text: window.player?.trackTitle ?? "Unknown Title"
                    }

                    StyledText {
                        id: desc

                        Layout.fillWidth: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        elide: Text.ElideRight
                        color: Colors.text.secondary
                        maximumLineCount: 2
                        // Height of two lines.
                        Layout.minimumHeight: 36
                        Layout.maximumHeight: 36
                        font.pointSize: 11
                        text: {
                            let txt = window.player?.trackArtist ?? "Unknown Artist";
                            if (window.player?.trackAlbum && window.player?.trackAlbum !== "")
                                // Only add artist if its relevant
                                txt = txt + " ~ " + window.player.trackAlbum;
                            return txt;
                        }

                        // Calculate font metrics for setting minimum line count
                        FontMetrics {
                            id: fm

                            font: desc.font
                        }
                    }
                }

                RowLayout {
                    TextIconButton {
                        text: "skip_previous"
                        size: 18
                        fill: true
                        visible: MprisService.canGoPrevious
                        color: MprisService.canGoPrevious ? colorQuantizer.result : Colors.text.secondary

                        onClicked: MprisService.previous()
                    }

                    StyledSlider {
                        configuration: StyledSlider.Configuration.Wavy
                        handleColor: colorQuantizer.result
                        trackColor: colorQuantizer.resultAlt
                        Layout.fillWidth: true
                        value: window.player?.position / window.player?.length ?? 0
                        waveAmplitudeMultiplier: MprisService.isPlaying ? 0.5 : 0

                        Behavior on value {
                            NumberAnimation {
                                easing.type: Easing.OutSine
                                duration: 200
                            }
                        }
                        Behavior on waveAmplitudeMultiplier {
                            NumberAnimation {
                                duration: 200
                            }
                        }

                        onMoved: window.player.position = value * window.player.length
                    }

                    TextIconButton {
                        text: "skip_next"
                        size: 18
                        fill: true
                        visible: MprisService.canGoNext
                        color: MprisService.canGoNext ? colorQuantizer.result : Colors.text.secondary

                        onClicked: MprisService.next()
                    }
                }

                RowLayout {
                    Layout.topMargin: -20
                    spacing: 0

                    StyledText {
                        text: window.formatTime(Math.floor(window.player?.position) ?? "0")
                        font.pointSize: 11
                        mono: true
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    TextIconButton {
                        text: switch (MprisService.loopState) {
                        case MprisLoopState.Playlist:
                            return "repeat_on";
                        case MprisLoopState.Track:
                            return "repeat_one_on";
                        default:
                            return "repeat";
                        }
                        size: 20
                        fill: true
                        font.bold: true
                        color: if (!MprisService.loopSupported)
                            return root.disabledButtonColor
                        else if (MprisService.loopState !== MprisLoopState.None)
                            return colorQuantizer.result
                        else
                            return Colors.text.secondary

                        onPressed: {
                            let newState;
                            // FIXME: Maybe cycle properly here.
                            if (MprisService.loopState === MprisLoopState.None)
                                newState = MprisLoopState.Track;
                            else
                                newState = MprisLoopState.None;
                            MprisService.setLoopState(newState);
                        }
                    }

                    TextIconButton {
                        text: !window.player?.isPlaying ? "play_arrow" : "pause"
                        size: 28
                        fill: true
                        color: colorQuantizer.result

                        onPressed: window.player?.togglePlaying()
                    }

                    TextIconButton {
                        text: MprisService.hasShuffle ? "shuffle_on" : "shuffle"
                        size: 20
                        fill: true
                        font.bold: true
                        color: MprisService.hasShuffle ? colorQuantizer.result : MprisService.shuffleSupported ? Colors.text.secondary : root.disabledButtonColor

                        onPressed: window.player.shuffle = !window.player.shuffle
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    StyledText {
                        text: window.formatTime(Math.floor(window.player?.length) ?? 0)
                        font.pointSize: 11
                        color: root.disabledButtonColor
                        mono: true
                    }
                }
            }

            HoverHandler {
                onHoveredChanged: if (!hovered)
                    window.close()
            }
        }

        onTrackArtUrlChanged: if (trackArtUrl) {
            content.crossfade(trackArtUrl);
            colorQuantizer.source = trackArtUrl;
        }

        // Calculate an accent from the track art URL.
        // Using just the accent color for the progressbar/others looks pretty jarring
        ColorQuantizer {
            id: colorQuantizer

            // The computed color.
            // Use the lightness of the accent since it looks nice.
            property color result: {
                let raw = Qt.color(Colors.accent);
                if (colors[0])
                    raw = Qt.color(colors[0]);
                let accent = Qt.color(Colors.accent);
                return Qt.hsla(raw.hslHue, accent.hslSaturation, accent.hslLightness, raw.a);
            }
            property color resultAlt: {
                let raw = Qt.color(Colors.accent);
                if (colors[0])
                    raw = Qt.color(colors[0]);
                let accent = Qt.color(Colors.accent);
                return Qt.hsla(raw.hslHue, accent.hslSaturation, accent.hslLightness, 0.33);
            }
            // For darkening the blurred background,
            //
            // Mostly to accomodate stuff that is way too out of range, for example, BilliumMoto's
            // LIGHT LEFT BEHIND is mostly white, so even when blurred, text may not appear well.
            property real averageBrightness: {
                if (colors.length === 0)
                    return 0;
                let total = 0;
                for (let i = 0; i < colors.length; i++) {
                    const c = colors[i];
                    // perceived luminance (Rec. 601 weights)
                    total += (0.299 * c.r + 0.587 * c.g + 0.114 * c.b);
                }
                return total / colors.length;
            }

            // We wait for the mediaArt source to load, then we load.
            source: window.hasTrackArt ? Qt.resolvedUrl(window.trackArtUrl) : ""
            depth: 0
            rescaleSize: 64
        }
    }
}
