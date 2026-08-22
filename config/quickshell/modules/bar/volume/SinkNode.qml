pragma ComponentBehavior: Bound

// A single widget/component representing a Sink node.
// This is for audio outputs, like your headphones/headsets.

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.components
import qs.components.styled

ColumnLayout {
    id: root

    // The tracked sink node.
    required property PwNode node

    implicitWidth: 400

    TextWithSub {
        text: root.node?.nickname ?? root.node?.name ?? "<Unknown Device>"
        subText: root.node?.description ?? null
        icon: "headset_mic"
        fill: false
    }
    StyledSlider {
        id: slider

        dividerValues: [0.8] // >80%: "danger" zone.
        usePercentTooltip: true
        configuration: StyledSlider.Configuration.M
        value: root.node?.audio?.volume ?? 0
        implicitWidth: 400
        from: 0
        to: 1

        onValueChanged: root.node.audio.volume = value
    }
}
