pragma Singleton
pragma ComponentBehavior: Bound

// Service to make accessing Mpris-based players more straightforward.
// Checks and simplifies if there are any null values.

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer trackedPlayer: null
    property MprisPlayer activePlayer: trackedPlayer ?? Mpris.players.values[0] ?? null
    property bool __reverse: false

    // Create binds for these since its easier than doing them inline everywhere.
    // MprisService.canWhatever is certainly much easier than checkig for null and idk...

    property bool isPlaying: this.activePlayer && this.activePlayer.isPlaying
    property bool canTogglePlaying: this.activePlayer?.canTogglePlaying ?? false
    // Playing skipping/track switching
    property bool canGoPrevious: this.activePlayer?.canGoPrevious ?? false
    property bool canGoNext: this.activePlayer?.canGoNext ?? false
    // Whether you can change stuff like looping/shuffling
    property bool canControl: this.activePlayer?.canControl ?? false
    // Volume changing.
    property bool canChangeVolume: this.activePlayer && this.activePlayer.volumeSupported && this.activePlayer.canControl
    // Looping. Ideally this would be on/off but I guess it's a little more complicated.
    property bool loopSupported: this.activePlayer && this.activePlayer.loopSupported && this.activePlayer.canControl
    property var loopState: this.activePlayer?.loopState ?? MprisLoopState.None
    // Shuffle. FIXME: Why some players are ass about this?
    property bool shuffleSupported: this.activePlayer && this.activePlayer.shuffleSupported && this.activePlayer.canControl
    property bool hasShuffle: this.activePlayer?.shuffle ?? false

    signal trackChanged(reverse: bool)

    function togglePlaying() {
        if (this.canTogglePlaying)
            this.activePlayer.togglePlaying();
    }

    function previous() {
        if (this.canGoPrevious) {
            this.__reverse = true;
            this.activePlayer.previous();
        }
    }

    function next() {
        if (this.canGoNext) {
            this.__reverse = false;
            this.activePlayer.next();
        }
    }

    function setLoopState(loopState: var) {
        if (this.activePlayer?.canControl) {
            this.activePlayer.loopState = loopState;
        }
    }

    function setShuffle(shuffle: bool) {
        this.activePlayer.shuffle = shuffle;
    }

    function setActivePlayer(player: MprisPlayer) {
        const targetPlayer = player ?? Mpris.players[0];
        console.log(`[Mpris] Active player ${targetPlayer} << ${activePlayer}`);

        if (targetPlayer && this.activePlayer) {
            this.__reverse = Mpris.players.indexOf(targetPlayer) < Mpris.players.indexOf(this.activePlayer);
        } else {
            // always animate forward if going to null
            this.__reverse = false;
        }

        this.trackedPlayer = targetPlayer;
    }

    Instantiator {
        model: Mpris.players

        Connections {
            required property MprisPlayer modelData

            function onPlaybackStateChanged() {
                if (root.trackedPlayer !== modelData)
                    root.trackedPlayer = modelData;
            }

            target: modelData

            Component.onCompleted: {
                if (root.trackedPlayer == null || modelData.isPlaying) {
                    root.trackedPlayer = modelData;
                }
            }
            Component.onDestruction: {
                if (root.trackedPlayer == null || !root.trackedPlayer.isPlaying) {
                    for (const player of Mpris.players.values) {
                        if (player.playbackState.isPlaying) {
                            root.trackedPlayer = player;
                            break;
                        }
                    }

                    if (root.trackedPlayer == null && Mpris.players.values.length != 0) {
                        root.trackedPlayer = Mpris.players.values[0];
                    }
                }
            }
        }
    }
}
