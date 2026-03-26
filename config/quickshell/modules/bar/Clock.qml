pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.components

Item {
    id: root

    readonly property string time: {
        // The passed format string matches the default output of
        // the `date` command.
        Qt.formatDateTime(clock.date, "hh:mm");
    }
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    required property var size

    implicitWidth: container.implicitWidth + size / 1.5
    implicitHeight: size

    Rectangle {
        id: container

        implicitWidth: rowLayout.width
        implicitHeight: rowLayout.height
        anchors.fill: parent
        color: ColorUtils.overlayColor(Colors.background.primary, Colors.background.tertiary, 0.2)

        radius: Appearance.radius()
        smooth: true

        RowLayout {
            id: rowLayout
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: root.time
                font.family: "Roboto Condensed"
                color: Colors.text.primary
            }
        }
    }
}
