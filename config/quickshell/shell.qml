//@ pragma UseQApplication
//@ pragma DropExpensiveFonts

pragma ComponentBehavior: Bound
import QtQuick

import Quickshell

import qs.modules.apps
import qs.modules.bar
import qs.modules.lock
import qs.modules.osd
import qs.modules.polkit
import qs.modules.wallpaper

ShellRoot {
    id: root

    ReloadPopup {}

    Apps {}

    Bar {}

    Osd {}

    Lock {}

    PolkitWindow {}

    Wallpaper {}

    ScreenCorners {}
}
