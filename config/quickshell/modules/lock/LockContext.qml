import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    // The current text in the password prompt
    property string currentText: ""
    property bool accountLocked: false
    property bool showFailure: false
    property string lastMessage: ""
    property bool unlockInProgress: false

    signal unlocked
    signal animate
    signal failed

    function tryUnlock() {
        if (currentText === "")
            return;
        root.unlockInProgress = true;
        pam.start();
    }

    // Only clear failure text when typing; keep lastMessage/accountLocked
    onCurrentTextChanged: showFailure = false

    PamContext {
        id: pam

        configDirectory: "config"
        config: "passwd.conf"

        onMessageChanged: {
            if (message.startsWith("The account is locked")) {
                root.lastMessage = message;
                root.accountLocked = true;
                return;
            } else if (message.toLowerCase().startsWith("password:") && !root.accountLocked) {
                root.accountLocked = false;
                return;
            }

            root.lastMessage = message;
        }
        onPamMessage: {
            if (this.responseRequired)
                this.respond(root.currentText);
        }
        onCompleted: result => {
            if (result == PamResult.Success) {
                // Clear lock and message only on successful login
                root.lastMessage = "";
                root.accountLocked = false;
                root.unlocked();
            } else {
                root.currentText = "";
                root.showFailure = true;
            }

            root.unlockInProgress = false;
        }
    }
}
