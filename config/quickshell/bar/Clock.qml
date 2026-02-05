pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.theme
import qs.components

// A clock doubling as a lastest notification viewer
// When a new notification hits, the clock "slides out" of the frame, shows the notification title
// and a cut off description, preview icon, and then slides back in.

Item {
    id: root

    required property var bar

    implicitWidth: container.implicitWidth
    implicitHeight: 50

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
    readonly property string time: Qt.formatDateTime(clock.date, "hh:mm")

    Rectangle {
        id: container

        anchors.fill: parent
        color: Colors.background.primary
        implicitWidth: contentRow.implicitWidth
        implicitHeight: contentRow.implicitHeight

        radius: 20
        smooth: true

        layer.enabled: true
        layer.effect: Shadow {}

        RowLayout {
            id: contentRow
            anchors.fill: parent

            Text {
                text: root.time
                color: Colors.text.primary
                font.family: "Roboto Condensed"
                renderType: Text.NativeRendering
                Layout.leftMargin: 20
                Layout.rightMargin: 20
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: false
            cursorShape: Qt.PointingHandCursor
            onClicked: testPopup.toggle()
        }
    }

    BarPopup {
        id: testPopup
        anchorItem: container
        bar: root.bar

        Text {
            text: "Hello"
        }
    }
}
