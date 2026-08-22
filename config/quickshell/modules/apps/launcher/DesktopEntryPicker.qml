pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Widgets
import qs.components.styled
import qs.theme
import qs.utils

StyledListView {
    id: root

    // Query to filter with. Leave empty to show all.
    property string query: ""
    property list<DesktopEntry> sortedApps: ([])

    function fuzzyMatch(needle, haystack) {
        return haystack.toLowerCase().includes(needle.toLowerCase());
    }

    snapMode: ListView.SnapOneItem

    model: ScriptModel {
        property string trimmed: root.query.trim()

        values: root.sortedApps.filter(entry => {
            if (trimmed === "")
                return true;
            return root.fuzzyMatch(root.query, entry.name + " " + (entry.comment || "") + " " + (entry.execString || ""));
        })
    }
    customDelegate: Row {
        id: row

        property int index
        property DesktopEntry modelData
        property bool selected

        spacing: 20

        IconImage {
            id: appIcon

            anchors.verticalCenter: parent.verticalCenter
            source: AppIconUtils.guessFromList([row.modelData.icon])
            visible: source.toString().length > 0
            implicitWidth: 40
            implicitHeight: 40
        }

        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

            StyledText {
                text: row.modelData?.name ?? ""
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
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
                text: row.modelData?.comment ?? ""
                visible: text.length !== 0
                font.pointSize: 11
                color: Colors.text.tertiary
                wrapMode: Text.Wrap
                Layout.maximumWidth: 700
            }
        }
    }

    Component.onCompleted: {
        sortedApps = DesktopEntries.applications.values.slice().sort((a, b) => a.name.localeCompare(b.name, Qt.locale().name));
    }

    Connections {
        function onValuesChanged() {
            root.sortedApps = DesktopEntries.applications.values.slice().sort((a, b) => a.name.localeCompare(b.name, Qt.locale().name));
        }

        target: DesktopEntries.applications
    }
}
