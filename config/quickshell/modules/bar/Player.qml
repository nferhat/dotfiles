pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.components
import qs.components.styled
import qs.modules.applets
import qs.services
import qs.theme
import qs.utils

ClippingRectangle {
    id: root

    required property int componentSize
    // FIXME: Type this.
    required property var config

    // FIXME: Allow the user to switch players.
    readonly property MprisPlayer player: MprisService.activePlayer
    readonly property bool hasTrack: player?.trackTitle !== "" ?? false

    implicitHeight: componentSize
    implicitWidth: contentLayout.width + 20
    color: Colors.background.primaryOverlay
    radius: Appearance.radius(-8)
    // Custom behavior to hide the player nicely.
    Layout.topMargin: hasTrack ? 0 : height + 100
    Layout.rightMargin: hasTrack ? 0 : -width

    // visible: Layout.topMargin !== height + 100

    Behavior on Layout.topMargin {
        animation: Animations.elementMoveEnter.numberAnimation(this)
    }
    Behavior on Layout.rightMargin {
        animation: Animations.elementMoveEnter.numberAnimation(this)
    }

    // Initialize the anchor, so that even opening with a keybind opens at the correct place.
    Component.onCompleted: Applets.media.anchor = root

    Image {
        id: trackArt

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Qt.url(root.player?.trackArtUrl ?? "")
        layer.enabled: true

        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            blurEnabled: true
            blur: 1
            blurMax: 16
            blurMultiplier: 1
            contrast: 0.05
            saturation: -0.25
            layer.enabled: true

            layer.effect: MultiEffect {
                autoPaddingEnabled: true
                blurEnabled: true
                blur: 1
                blurMax: 32
                blurMultiplier: 0.5
            }
        }
    }

    // The gradient, to make things look nicer, and darken the image even more.
    // I don't use music players, so I only really need to see roughly what the thumbnail im looking
    // at, nothing more.
    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            orientation: Gradient.Horizontal

            GradientStop {
                position: 0
                color: Colors.background.primaryOverlay
            }

            GradientStop {
                position: root.config.showProgress ? 0.5 : 1
                color: "transparent"
            }
        }
    }

    TapHandler {
        onTapped: Applets.media.toggle(root)
    }

    RowLayout {
        id: contentLayout

        anchors.centerIn: parent
        spacing: 10

        RowLayout {
            spacing: 10
            visible: root.config.showPlayerIcon

            Item {
                implicitHeight: 18
                implicitWidth: height

                IconImage {
                    id: iconImage

                    anchors.fill: parent
                    source: AppIconUtils.guessFromList([root.player?.identity ?? "", root.player?.desktopEntry ?? ""])
                    visible: source.toString().length > 0
                }

                MaterialIcon {
                    visible: !iconImage.visible
                    size: 20
                    anchors.centerIn: parent
                    text: "music_note"
                }
            }

            Separator {
                vert: true
                color: Colors.text.tertiary
            }
        }

        RowLayout {
            id: timeInfo

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

            spacing: 0
            visible: root.config.showProgress
            Layout.alignment: Qt.AlignVCenter

            Timer {
                running: root.config.progress.show
                interval: 1000
                repeat: true

                onTriggered: root.player?.positionChanged()
            }

            StyledText {
                text: timeInfo.formatTime(Math.floor(root.player?.position) ?? 0)
                mono: true
                font.pointSize: 10
            }

            StyledText {
                readonly property int hours: root.player?.length / 3600
                readonly property int minutes: root.player?.length / 60
                readonly property int seconds: root.player?.length % 60

                visible: root.config.progress.showTotal
                mono: true
                text: "/" + timeInfo.formatTime(Math.floor(root.player?.length) ?? 0)
                color: ColorUtils.transparentize(Colors.text.primary, 0.33)
                font.pointSize: 10
            }
        }
    }
}
