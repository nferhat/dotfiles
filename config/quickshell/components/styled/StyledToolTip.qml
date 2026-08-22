import QtQuick
import QtQuick.Controls
import qs.theme

ToolTip {
    id: root

    property string tooltipText: ""
    property bool show: false

    text: tooltipText
    delay: 1000
    timeout: -1
    visible: show && tooltipText.length > 0

    background: Rectangle {
        color: Colors.background.secondary
        radius: Appearance.radius(-8)
    }
    contentItem: StyledText {
        text: root.tooltipText
        color: Colors.text.secondary
        font.pixelSize: 14
        font.bold: true
    }
}
