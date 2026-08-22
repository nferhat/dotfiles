import QtQuick
import QtQuick.Layouts
import qs.components.styled
import qs.theme

RowLayout {
    id: root

    required property string text
    property string subText: ""
    property string icon: ""
    property color iconColor: Colors.accent
    property bool fill: false
    property alias textFont: textW.font
    property alias subTextFont: subTextW.font

    spacing: 7

    MaterialIcon {
        text: root.icon
        visible: textW !== ""
        Layout.alignment: Qt.AlignCenter
        color: root.iconColor
        font.bold: true
        size: 24
        fill: root.fill
    }
    ColumnLayout {
        spacing: 0
        Layout.leftMargin: 5

        StyledText {
            id: textW

            text: root.text
            font.pointSize: 14
        }
        StyledText {
            id: subTextW

            text: root.subText
            visible: text !== ""
            font.family: Appearance.fonts.monospace
            color: Colors.text.tertiary
        }
    }
}
