import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    property bool vert: false

    color: Colors.separator
    // opacity: 0.1
    radius: 1

    implicitWidth: vert ? 2 : 20
    implicitHeight: vert ? 20 : 2

    Layout.fillWidth: !vert
    Layout.fillHeight: vert
}
