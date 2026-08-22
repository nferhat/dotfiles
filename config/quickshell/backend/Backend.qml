pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string backendDirName: "/qs-backend/"

    function getFilePath(name: string): string {
        return Quickshell.env("XDG_STATE_HOME") + backendDirName + name;
    }

    // Process {
    //     id: backendProcess
    //     command: ["/home/nferhat/.config/quickshell/backend-src/target/debug/backend"]
    //     running: true
    //     stdinEnabled: true
    //     // FIXME: Not crash whenever I recompile the program.
    //     stdout: SplitParser {
    //         onRead: line => {
    //             let event = JSON.parse(line);
    //             switch (event.kind) {
    //             case "Weather":
    //                 root.weather.update(event.data);
    //                 break;
    //             }
    //         }
    //     }
    // }
}
