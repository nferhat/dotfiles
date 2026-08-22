import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.components.styled
import qs.theme

ColumnLayout {
    spacing: 10

    TextWithSub {
        text: "Most used apps this session"
        subText: "(Based on focused time)"
        icon: ""
        fill: true
    }
    GridLayout {
        Layout.fillWidth: true
        columns: 3
        rows: 2
        columnSpacing: 10
        rowSpacing: 10

        Repeater {
            model: [
                {
                    title: "Zed",
                    app_id: "dev.zed.Zed",
                    time: "7h 33m"
                },
                {
                    title: "Ghostty",
                    app_id: "com.mitchellh.ghostty",
                    time: "3h 28m"
                },
                {
                    title: "Librewolf",
                    app_id: "librewolf",
                    time: "2h 45m"
                },
                {
                    title: "Vesktop",
                    app_id: "vesktop",
                    time: "1h 28m"
                },
                {
                    title: "GT:NH 2.8.4",
                    app_id: "minecraft*",
                    time: "57m"
                },
            ]

            delegate: Rectangle {
                id: delegate

                required property var modelData
                required property int index

                radius: Appearance.radius(-8)
                color: Colors.background.primary
                Layout.preferredHeight: delegateLayout.height + 20
                Layout.fillWidth: true

                ColumnLayout {
                    id: delegateLayout

                    width: parent.width - 20
                    anchors.centerIn: parent
                    spacing: 0

                    RowLayout {
                        spacing: 10

                        IconImage {
                            source: Quickshell.iconPath(delegate.modelData.app_id)
                            visible: Quickshell.hasThemeIcon(delegate.modelData.app_id)
                            implicitWidth: 32
                            implicitHeight: 32
                        }
                        ColumnLayout {
                            spacing: -5

                            StyledText {
                                text: delegate.modelData.title
                                font.bold: true
                                font.pixelSize: 20
                            }
                            StyledText {
                                text: delegate.modelData.app_id
                                font.pixelSize: 12
                                color: Colors.text.tertiary
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        MaterialIcon {
                            visible: delegate.index === 0
                            Layout.alignment: Qt.AlignRight
                            Layout.rightMargin: 5
                            fill: true
                            color: Colors.ansi.color3
                            text: "crown"
                        }
                    }
                    StyledText {
                        Layout.topMargin: 5
                        color: delegate.index === 0 ? Colors.text.primary : Colors.text.secondary
                        font.pixelSize: 30
                        font.bold: true
                        text: delegate.modelData.time
                    }
                }
            }
        }
    }
}
