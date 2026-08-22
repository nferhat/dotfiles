import QtQuick
import qs.components.styled
import qs.theme

MaterialIcon {
    id: root

    required property int count

    text: "notifications"

    Rectangle {
        radius: 100
        implicitHeight: 15
        implicitWidth: 15
        color: Colors.ansi.color1
        anchors.top: parent.top
        anchors.right: parent.right

        StyledText {
            color: Colors.text.primary
            text: root.count > 9 ? "9+" : root.count
            font.pointSize: 8
            anchors.centerIn: parent
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
