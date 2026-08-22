pragma ComponentBehavior: Bound

// A re-usable applet panel, anchored to a widget on the bar.

import QtQuick
import Quickshell

Scope {
    id: root

    // The anchored window to use. Make sure its of type [AnchoredPanel] else
    // it's going to fail miserably.
    required property Component window
    // Whether the applet is currently opened
    property bool opened: false
    // The last anchor used for this panel.
    property Item anchor: null

    // Opens the panel, and optionally change the anchor if passed in
    function open(newAnchor: Item) {
        if (newAnchor)
            anchor = newAnchor;

        // qmllint disable missing-property
        opened = true;
        if (loader.active) {
            // The loader was already active, we can just re-use the existing anchored panel.
            loader.item.anchor = anchor;
            loader.item.open();
        } else {
            // Create a new instance of the component, with the anchor passed in.
            loader.active = true;
            loader.item.anchor = anchor;
        }
    }

    Connections {
        target: loader.item
        function onDoneClosing() {
            root.opened = false // FIXME: Why should I have todo this here?
            loader.active = false;
        }
    }

    // Closes the panel.
    function close() {
        // This will only start the closing animation.
        loader.item.close();
        opened = false;
    }

    function toggle(anchor) {
        if (opened)
            close();
        else
            open(anchor);
    }

    LazyLoader {
        id: loader

        component: root.window
    }
}
