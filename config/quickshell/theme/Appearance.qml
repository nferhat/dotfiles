// qmllint disable missing-property
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    readonly property real cornerRadius: 16
    readonly property QtObject fonts: QtObject {
        readonly property string monospace: "Zed Mono"
        readonly property string regular: "Iosevka Aile"
    }

    /// Gets a corner radius value with a given offset.
    function radius(offset = 0) {
        return cornerRadius > 0 ? cornerRadius + offset : 0;
    }
}
