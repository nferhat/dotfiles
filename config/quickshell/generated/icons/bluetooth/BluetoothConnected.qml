// Generated from SVG file bluetooth-connected.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes

Item {
    id: __qt_toplevel
    property int size: 16
    property color dotsColor: "blue"
    property color bluetoothIconColor: "blue"

    implicitWidth: size
    implicitHeight: size
    component AnimationsInfo: QtObject {
        property bool paused: false
        property int loops: 1
        signal restart
    }
    property AnimationsInfo animations: AnimationsInfo {}
    transform: [
        Scale {
            xScale: width / 256
            yScale: height / 256
        }
    ]
    Shape {
        id: _qt_node0
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: _qt_shapePath_0
            strokeColor: __qt_toplevel.bluetoothIconColor
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 128 32 L 192 80 L 128 128 L 128 32 "
            }
        }
        ShapePath {
            id: _qt_shapePath_1
            strokeColor: __qt_toplevel.bluetoothIconColor
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 128 128 L 192 176 L 128 224 L 128 128 "
            }
        }
        ShapePath {
            id: _qt_shapePath_2
            strokeColor: __qt_toplevel.bluetoothIconColor
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 64 80 L 128 128 "
            }
        }
        ShapePath {
            id: _qt_shapePath_3
            strokeColor: __qt_toplevel.bluetoothIconColor
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 64 176 L 128 128 "
            }
        }
        ShapePath {
            id: _qt_shapePath_4
            strokeColor: __qt_toplevel.dotsColor
            fillColor: __qt_toplevel.dotsColor
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 72 128 C 72 136.837 64.8366 144 56 144 C 47.1634 144 40 136.837 40 128 C 40 119.163 47.1634 112 56 112 C 64.8366 112 72 119.163 72 128 "
            }
        }
        ShapePath {
            id: _qt_shapePath_5
            strokeColor: __qt_toplevel.dotsColor
            fillColor: __qt_toplevel.dotsColor
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 224 128 C 224 136.837 216.837 144 208 144 C 199.163 144 192 136.837 192 128 C 192 119.163 199.163 112 208 112 C 216.837 112 224 119.163 224 128 "
            }
        }
    }
}
