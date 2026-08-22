import QtQuick
import QtQuick.Layouts
import qs.components.styled
import qs.theme

RowLayout {
    property string icon: ""
    property string name: ""
    property string kind: "material"

    spacing: 7

    MaterialIcon {
        text: parent.icon
        Layout.topMargin: 3
        color: Colors.text.tertiary
        visible: parent.kind === "material"
    }
    PhosphorIcon {
        text: parent.icon
        Layout.topMargin: 3
        color: Colors.text.tertiary
        visible: parent.kind === "phosphor"
    }
    StyledText {
        font.pointSize: 11
        color: ColorUtils.transparentize(Colors.text.primary, 0.5)
        mono: true
        text: parent.name
    }
}
