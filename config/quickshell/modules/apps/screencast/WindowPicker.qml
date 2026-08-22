pragma ComponentBehavior: Bound

import Fhtc
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.components.styled
import qs.theme
import qs.utils

StyledListView {
    id: root

    property var windows: FhtcWorkspaces.windows
    property var windowIds: Object.keys(windows)
    readonly property var selectedWindow: windows[windowIds[currentIndex]]

    height: 400
    model: windowIds

    customDelegate: Row {
        id: row

        property int index
        property int modelData // window ID
        property int selected
        readonly property var window: root.windows[root.windowIds[index]]
        readonly property int windowId: modelData

        spacing: 10

        IconImage {
            id: appIcon

            source: AppIconUtils.guessFromList([row.window["app-id"] ?? "", row.window.title])
            visible: source.toString().length > 0
            implicitWidth: 32
            implicitHeight: 40

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                }
            }
        }

        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignLeft

            StyledText {
                text: row.window?.title ?? ""
                font.weight: row.selected ? 700 : 400
                // NOTE: QtRendering allows to smoothly animate the weight
                // property, instead of NativeRendering (which uses whatever)
                renderType: Text.QtRendering

                Behavior on font.weight {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }

            StyledText {
                text: row.window["app-id"]
                font.pointSize: 11
                color: Colors.text.tertiary
                mono: true
            }
        }
    }
}
