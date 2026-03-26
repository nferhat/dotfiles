// Generated from SVG file wifi-x.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes

Item {
    implicitWidth: 256
    implicitHeight: 256
    component AnimationsInfo : QtObject
    {
        property bool paused: false
        property int loops: 1
        signal restart()
    }
    property AnimationsInfo animations : AnimationsInfo {}
    transform: [
        Scale { xScale: width / 256; yScale: height / 256 }
    ]
    id: __qt_toplevel
    Shape {
        id: _qt_node0
        ShapePath {
            id: _qt_shapePath_0
            strokeColor: "transparent"
            fillColor: "#ff000000"
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 144 204 C 144 212.837 136.837 220 128 220 C 119.163 220 112 212.837 112 204 C 112 195.163 119.163 188 128 188 C 136.837 188 144 195.163 144 204 " }
        }
        ShapePath {
            id: _qt_shapePath_1
            strokeColor: "#ff000000"
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 224 56 L 176 104 " }
        }
        ShapePath {
            id: _qt_shapePath_2
            strokeColor: "#ff000000"
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 224 104 L 176 56 " }
        }
        ShapePath {
            id: _qt_shapePath_3
            strokeColor: "#ff000000"
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 168 165 C 144.154 147.655 111.846 147.655 88 165 " }
        }
        ShapePath {
            id: _qt_shapePath_4
            strokeColor: "#ff000000"
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 128 56 C 90.0662 55.9418 53.2953 69.0909 24 93.19 " }
        }
        ShapePath {
            id: _qt_shapePath_5
            strokeColor: "#ff000000"
            strokeWidth: 24
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 128 104 C 101.863 103.947 76.4803 112.761 56 129 " }
        }
    }
}
