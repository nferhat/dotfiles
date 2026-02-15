pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.theme
import qs.components

Item {
    id: root

    required property var size

    // State fetched from Mpris itself
    property MprisPlayer player: Mpris.players.values[0]

    property bool isPlaying: player?.playbackState === MprisPlaybackState.Playing
    property bool canSeek: player?.canSeek
    property real position: player?.position ?? 0.0
    property real length: player?.length ?? 1.0
    property bool hasArtwork: (player?.trackArtUrl ?? "") !== ""
    // We recolor the progressbar using colors from the image artwork
    ColorQuantizer {
        id: artworkColorQuantizer
        source: Qt.url(root.player?.trackArtUrl ?? "")
        depth: 1 // we only need one color, so we take the first one
        rescaleSize: 128 // Rescale to 64x64 for faster processing
    }
    property color artworkAccentColor: ColorUtils.brighterColor(artworkColorQuantizer.colors[0], artworkColorQuantizer.colors[1])

    // We make use of the following signals in order to hide/show the player in "cool" ways.
    // See Bar.qml, where this widget is instanciated
    signal hide
    signal show

    Connections {
        target: root
        function onPlayerChanged() {
            if (root.player)
                root.show();
            else
                root.hide();
        }
    }
    Component.onCompleted: {
        if (root.player)
            root.show();
        else
            root.hide();
    }

    Timer {
        running: root.isPlaying
        interval: 1000
        repeat: true
        onTriggered: {
            if (!barSlider.pressed && !barSlider.isHovered && root.player) {
                barSlider.value = root.length > 0 ? Math.min(1.0, root.position / root.length) : 0;
            }
            root.player?.positionChanged();
        }
    }
    Connections {
        target: root.player
        function onPositionChanged() {
            if (!barSlider.pressed && root.player) {
                barSlider.value = root.length > 0 ? Math.min(1.0, root.position / root.length) : 0;
            }
        }
    }

    function getPlayerIcon() {
        if (!player)
            return "";
        const dbusName = (player.dbusName || "").toLowerCase();
        const desktopEntry = (player.desktopEntry || "").toLowerCase();
        const identity = (player.identity || "").toLowerCase();
        if (dbusName.includes("spotify") || desktopEntry.includes("spotify") || identity.includes("spotify"))
            return "";
        if (dbusName.includes("firefox") || desktopEntry.includes("firefox") || desktopEntry.includes("librewolf"))
            return "";
        if (dbusName.includes("telegram") || desktopEntry.includes("telegram") || identity.includes("telegram"))
            return "";
        return "";
    }

    implicitWidth: container.implicitWidth + size / 1.5
    implicitHeight: size

    Rectangle {
        id: container

        implicitWidth: 200
        implicitHeight: root.size
        anchors.fill: parent
        color: Colors.background.primary

        radius: Appearance.radius()
        smooth: true

        ClippingRectangle {
            anchors.fill: parent
            radius: Appearance.radius()
            color: "transparent"

            Image {
                id: backgroundArt
                anchors.fill: parent
                source: Qt.url(root.player?.trackArtUrl ?? "")
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                visible: false
            }

            MultiEffect {
                anchors.fill: backgroundArt
                source: backgroundArt
                blurEnabled: true
                blurMax: 64
                blur: 0.5
                autoPaddingEnabled: false
                opacity: root.hasArtwork ? 1.0 : 0.0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 275
                        easing.type: Easing.OutQuart
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                opacity: root.hasArtwork ? 0.5 : 0.0
                color: Colors.ansi.color0
                radius: Appearance.radius()
                Behavior on opacity {
                    NumberAnimation {
                        duration: 275
                        easing.type: Easing.OutQuart
                    }
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 10
            anchors.leftMargin: 8
            anchors.rightMargin: 12

            Text {
                id: playPauseButton
                opacity: root.player?.canPause ?? false ? 1.0 : 0.3
                text: root.player?.isPlaying ? "" : ""
                color: root.artworkAccentColor
                scale: 1.0
                font.family: "Phosphor-Bold"
                font.pixelSize: 20

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        playPauseButton.scale = 0.9;
                        root.player?.togglePlaying();
                        playPauseScaleTimer.restart();
                    }
                }

                // Make the scale button scale in and out
                Behavior on scale {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.5
                    }
                }
                Timer {
                    id: playPauseScaleTimer
                    interval: 150
                    onTriggered: playPauseButton.scale = 1.0
                }
            }

            MuiSlider {
                id: barSlider

                activeColor: root.hasArtwork ? root.artworkAccentColor : Colors.accent
                inactiveColor: ColorUtils.transparentize(Colors.text.secondary, 0.5)
                handleColor: root.hasArtwork ? ColorUtils.mix(root.artworkAccentColor, Colors.text.primary, 0.6) : Colors.accent

                Layout.fillWidth: true
                Layout.preferredHeight: 40

                onMoved: {
                    if (pressed && root.player && root.player.canSeek) {
                        root.player.position = value * root.length;
                    }
                }
            }

            // Text {
            //     text: root.getPlayerIcon()
            //     color: Colors.ansi.color7
            //     font.family: "Phosphor-Bold"
            //     font.pixelSize: 20
            // }
        }
    }
}
