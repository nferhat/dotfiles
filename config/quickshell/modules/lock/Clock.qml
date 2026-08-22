import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.components.styled
import qs.theme

ColumnLayout {
    id: root

    spacing: -10

    StyledText {
        Layout.alignment: Qt.AlignCenter
        font.pixelSize: 64
        font.bold: true
        color: Colors.accent
        text: Qt.formatDateTime(clock.date, "HH:MM")
        layer.enabled: true

        layer.effect: Shadow {
        }
    }
    StyledText {
        Layout.alignment: Qt.AlignCenter
        font.pixelSize: 24
        text: Qt.formatDateTime(clock.date, "dddd dd MMM, yyyy")
        layer.enabled: true

        layer.effect: Shadow {
        }
    }
    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }
}
