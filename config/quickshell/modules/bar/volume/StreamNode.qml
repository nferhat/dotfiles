pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

// A single widget/component representing a Stream node (node.isStream)
// Custom logic to fetch application icon and whatnot.

import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import qs.components.styled
import qs.theme
import qs.utils

ColumnLayout {
    id: root

    // The tracked sink node.
    required property PwNode node
    readonly property PwNodeAudio audio: node?.audio
    readonly property string appName: node.properties["application.name"] ?? ""
    readonly property string appIcon: node.properties["application.icon-name"] ?? ""
    // Media information. It really doesn't mean anything, just to fill the space
    // really...
    readonly property string mediaClass: node.properties["media.class"] ?? "<unknown>"
    readonly property string mediaName: node.properties["media.name"] ?? "Player"

    implicitWidth: 400

    // To access properties
    PwObjectTracker {
        objects: [root.node]
    }

    // Adapted from TextWithSub. 27 is similar to the size of a TextWithSub with correct sizing.
    // Whatever.
    RowLayout {
        IconImage {
            id: appIcon

            source: {
                let icon;
                icon = AppIconUtils.guessIcon(root.appIcon);
                if (AppIconUtils.iconExists(icon))
                    return Quickshell.iconPath(icon);
                icon = AppIconUtils.guessIcon(root.appName);
                if (AppIconUtils.iconExists(icon))
                    return Quickshell.iconPath(icon);
            }
            visible: source !== undefined && source !== null
            implicitWidth: 27
            implicitHeight: 27
        }
        ColumnLayout {
            spacing: -2.5
            Layout.leftMargin: 5

            StyledText {
                text: root.appName
            }
            StyledText {
                text: root.mediaClass + " | " + root.mediaName
                visible: text !== ""
                font.pixelSize: 14
                color: Colors.text.tertiary
            }
        }
    }
    StyledSlider {
        id: slider

        dividerValues: [0.8] // >80%: "danger" zone.
        usePercentTooltip: true
        configuration: StyledSlider.Configuration.M
        value: root.audio?.volume
        implicitWidth: 400
        from: 0
        to: 1

        onValueChanged: root.audio.volume = value
    }
}
