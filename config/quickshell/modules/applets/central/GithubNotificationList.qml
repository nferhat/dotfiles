pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.backend
import qs.components
import qs.components.styled
import qs.theme

ListView {
    id: root

    readonly property color usernameColor: ColorUtils.mix(Colors.text.tertiary, Colors.accent, 0.85)
    readonly property color repoColor: ColorUtils.transparentize(Colors.text.primary, 0.5)
    readonly property color numberColor: Colors.text.tertiary

    implicitHeight: 330
    spacing: 20
    interactive: true
    clip: true
    snapMode: ListView.SnapOneItem
    model: Github.notifications

    delegate: RowLayout {
        id: row

        required property var modelData
        // Untagged enum representation.
        readonly property var kind: modelData.kind
        readonly property var notification: modelData.data

        spacing: 15

        PhosphorIcon {
            // Using octicons here, since they contain all the variants (including closed PR/issue)
            // They also make it look like its really github, haha
            font.family: "Iosevka Nerd Font"
            text: switch (row.kind) {
            case "Issue":
                return row.notification.completed ? "" : "";
            case "PullRequest":
                if (row.notification.status === "Closed")
                    return "";
                else if (row.notification.status === "Merged")
                    return "";
                else
                    return "";
            case "Discussion":
                return "";
            default:
                return "";
            }
            color: switch (row.kind) {
            case "Issue":
                if (row.notification.completed)
                    return Colors.ansi.color5;
                if (row.notification.closed)
                    return Colors.ansi.color1;
                else
                    return Colors.ansi_bright.color10;
            case "PullRequest":
                if (row.notification.status === "Closed")
                    return Colors.ansi.color1;
                else if (row.notification.status === "Merged")
                    return Colors.ansi.color5;
                else
                    return Colors.ansi.color2;
            case "Discussion":
                return Colors.text.tertiary;
            default:
                return "";
            }
            Layout.topMargin: 5
            Layout.alignment: Qt.AlignTop
            size: 24
        }

        ColumnLayout {
            spacing: 0
            Layout.fillWidth: true

            StyledText {
                // HACK: Using inline span so that the issue number doesn't force the text to wrap on a separate
                // starting boundary. I would have loved to use a RowLayout but alas.
                text: row.notification.number !== undefined ? `<span style="font-family: monospace; color: ${root.numberColor};">#${row.notification.number}</span> ` + row.notification.title : row.notification.title
                textFormat: Text.RichText
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pointSize: 12
                Layout.preferredWidth: 600
            }

            RowLayout {
                spacing: 2

                MaterialIcon {
                    visible: row.notification.fork ?? false
                    size: 16
                    color: Colors.text.tertiary
                    text: "call_split"
                }

                StyledText {
                    text: row.notification.repository
                    color: root.repoColor
                    mono: true
                    font.pointSize: 10
                }

                PhosphorIcon {
                    text: ""
                    color: root.repoColor
                }

                StyledText {
                    text: "@" + row.notification.author
                    color: root.usernameColor
                    mono: true
                    font.pointSize: 10
                }
            }
        }

        PhosphorIcon {
            text: ""
            fill: false
            color: Colors.text.tertiary
            Layout.alignment: Qt.AlignVCenter
            opacity: hoverHandler.hovered ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                }
            }
        }

        HoverHandler {
            id: hoverHandler
        }
    }
}
