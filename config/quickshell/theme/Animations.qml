// qmllint disable missing-property
pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick

// Pre-defined animation values to be reused in the shell.

import Quickshell

Singleton {
    id: root

    // Copied from end-4/hypr-dots and AxOS-project/Sleex
    readonly property QtObject animationCurves: QtObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1] // Default, 350ms
        readonly property list<real> expressiveDefaultSpatial: [0.38, 0.75, 0.22, 1.00, 1, 1] // Default, 500ms
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1] // Default, 650ms
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1] // Default, 200ms
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        readonly property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property real expressiveFastSpatialDuration: 350
        readonly property real expressiveDefaultSpatialDuration: 500
        readonly property real expressiveSlowSpatialDuration: 1500
        readonly property real expressiveEffectsDuration: 200
    }
    readonly property BezierAnimation elementMove: BezierAnimation {
        curve: root.animationCurves.expressiveEffects
        duration: root.animationCurves.expressiveDefaultSpatialDuration
        velocity: 650
    }
    readonly property BezierAnimation elementMoveFast: BezierAnimation {
        curve: root.animationCurves.expressiveEffects
        duration: root.animationCurves.expressiveFastSpatialDuration
        velocity: 850
    }
    readonly property BezierAnimation elementMoveSlow: BezierAnimation {
        curve: root.animationCurves.expressiveEffects
        duration: root.animationCurves.expressiveSlowSpatialDuration
        velocity: 2000
    }
    readonly property BezierAnimation elementMoveEnter: BezierAnimation {
        curve: root.animationCurves.emphasizedDecel
        duration: 200
        velocity: 650
    }
    readonly property BezierAnimation elementMoveExit: BezierAnimation {
        curve: root.animationCurves.emphasizedAccel
        duration: 200
        velocity: 650
    }

    component BezierAnimation: QtObject {
        id: bezierAnim

        required property int duration
        required property list<real> curve
        required property int velocity
        property Component __numberAnimation: Component {
            NumberAnimation {
                duration: bezierAnim.duration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: bezierAnim.curve
            }
        }
        property Component __colorAnimation: Component {
            ColorAnimation {
                duration: bezierAnim.duration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: bezierAnim.curve
            }
        }

        function numberAnimation(_parent: Item): QtObject {
            return __numberAnimation.createObject(this);
        }

        function colorAnimation(_parent: Item): QtObject {
            return __colorAnimation.createObject(this);
        }
    }
}
