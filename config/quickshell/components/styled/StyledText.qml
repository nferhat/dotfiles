import QtQuick
import qs.theme

Text {
    property bool mono: false

    font.family: mono ? Appearance.fonts.monospace : Appearance.fonts.regular
    renderType: Text.NativeRendering
    renderTypeQuality: Text.VeryHighRenderTypeQuality
    color: Colors.text.primary
}
