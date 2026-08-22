import QtQuick
import qs.theme

Text {
    id: root

    property real size: 16
    // The iconSize. This is done to change the variant.
    property real opticalSize: size
    // The fill value. It's an axis from 0-1, but we realistically only need filled
    // and not filled. Other values are not relevant here.
    property bool fill: true

    renderType: Text.NativeRendering
    renderTypeQuality: Text.VeryHighRenderTypeQuality
    antialiasing: true
    verticalAlignment: Text.AlignVCenter
    color: Colors.accent

    font {
        hintingPreference: Font.PreferFullHinting
        family: "Material Symbols Rounded"
        pixelSize: size
        variableAxes: {
            "FILL": root.fill ? 1 : 0,
            "GRAD": 0,
            "opsz": root.opticalSize
        }
    }

    // Behavior on fill {
    //     NumberAnimation {
    //         duration: Appearance?.animation.elementMoveFast.duration ?? 200
    //         easing.type: Appearance?.animation.elementMoveFast.type ?? Easing.BezierSpline
    //         easing.bezierCurve: Appearance?.animation.elementMoveFast.bezierCurve ?? [0.34, 0.80, 0.34, 1.00, 1, 1]
    //     }
    // }
}
