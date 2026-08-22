pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import qs.modules.applets.central

Singleton {
    property AppletPanel media: MediaApplet {}
    property CentralApplet central: CentralApplet {}
}
