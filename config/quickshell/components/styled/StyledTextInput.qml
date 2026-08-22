import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import qs.theme

TextField {
    color: Colors.text.primary
    selectionColor: ColorUtils.mix(Colors.accent, Colors.background.tertiary, 0.6)
    selectedTextColor: ColorUtils.mix(Colors.accent, Colors.text.primary, 0.5)
    placeholderTextColor: Colors.text.tertiary
    font.family: Appearance.fonts.regular
    leftPadding: 10
    rightPadding: 10

    background: Rectangle {
        color: ColorUtils.transparentize(Colors.text.primary, 0.98)
        radius: Appearance.radius(-1)
        implicitWidth: 350
        implicitHeight: 50
    }
}
