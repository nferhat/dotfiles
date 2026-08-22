import QtQuick
import qs.theme

Text {
    id: root

    property real size: 16
    property bool fill: false

    renderType: Text.NativeRendering
    renderTypeQuality: Text.VeryHighRenderTypeQuality
    antialiasing: true
    color: Colors.accent

    font {
        hintingPreference: Font.PreferFullHinting
        family: root.fill ? "Phosphor-Fill" : "Phosphor"
        pixelSize: size
    }

    // Behavior on fill {
    //     NumberAnimation {
    //         duration: Appearance?.animation.elementMoveFast.duration ?? 200
    //         easing.type: Appearance?.animation.elementMoveFast.type ?? Easing.BezierSpline
    //         easing.bezierCurve: Appearance?.animation.elementMoveFast.bezierCurve ?? [0.34, 0.80, 0.34, 1.00, 1, 1]
    //     }
    // }
}
