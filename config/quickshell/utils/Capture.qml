pragma ComponentBehavior: Bound

// A workaround for the lockscreen and fullscreen prompts.
// Capture the screen manually using grim since quickshell crashes with screencopyviews.

import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    // We create temporary files so we need a way to distinguish them.
    required property string namespace

    signal ready

    function start() {
        let cmds = [];
        const screens = Quickshell.screens;
        for (let i = 0; i < screens.length; i++) {
            const name = screens[i].name;
            cmds.push(`grim -o '${name}' -t png -l 0 '/tmp/${namespace}-screen-${name}'`);
        }
        screenshotProcess.command = ["sh", "-c", cmds.join(" && ")];
        screenshotProcess.running = true;
    }

    function imageFor(screen: string): url {
        return Qt.url(`/tmp/${namespace}-screen-${screen}`);
    }

    Process {
        id: screenshotProcess

        onExited: (code, status) => root.ready()
    }
}
