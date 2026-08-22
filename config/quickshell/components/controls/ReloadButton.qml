pragma ComponentBehavior: Bound

// A button that spins around, indicating a refresh/reload/whatever.

import QtQuick
import qs.theme

IconButton {
    id: root

    text: "replay"
    implicitWidth: height
    size: 18
    font.bold: true
    color: Colors.accent

    background: Item {
    }
    NumberAnimation on rotation {
        id: spinAnimation

        from: 0
        to: -360
        duration: 500
        running: false
        easing.type: Easing.InOutQuad
    }

    Connections {
        function onClicked() {
            spinAnimation.start();
        }

        target: root
    }
}
