import QtQuick
import QtQuick.Layouts
import qs.components.styled
import qs.theme

Rectangle {
    id: root

    property int pad: 30
    required property var lines

    radius: Appearance.radius(-8)
    color: Colors.background.primary
    implicitHeight: layout.height + pad
    layer.enabled: true

    layer.effect: Shadow {
        shadowOpacity: 0.25
    }

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        width: parent.width - parent.pad
        spacing: 1

        Repeater {
            model: root.lines

            delegate: RowLayout {
                required property var modelData

                Layout.fillWidth: true

                StyledText {
                    text: parent.modelData.title
                    Layout.fillWidth: true
                    color: Colors.text.tertiary
                }
                StyledText {
                    text: parent.modelData.value
                    font.bold: true
                    color: parent.modelData.color ?? Colors.text.primary
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }
}
