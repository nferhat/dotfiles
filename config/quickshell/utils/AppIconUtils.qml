pragma Singleton

// Service/helper for handling app icons.
// Fuck the linux desktop (sometimes)

import Quickshell

Singleton {
    id: root

    // Hardcoded substitutions for stuff that doesn't match nicely.
    property var substitutions: ({
            "gnome-tweaks": "org.gnome.tweaks",
            "minecraft*": "minecraft",
            "Celeste": "steam_icon_504230"
        })
    // Regex substitutions, uhh, idk
    property var regexSubstitutions: [
        // NOTE: For steam icons to work properly, you have to right-click -> install desktop shortcut
        // or something like that, for it to install a shortcut and the app icon in ~/.local/share/icons
        {
            "regex": /^steam_app_(\d+)$/,
            "replace": "steam_icon_$1"
        },
        {
            "regex": /Minecraft.*/,
            "replace": "minecraft"
        },
    ]
    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values).sort((a, b) => a.name.localeCompare(b.name))

    // Tries to guess an icon based on a list of candidates. Returns the first one that matches.
    // Possible canditates to pass into this function are: app ids, dbus-names, titles...
    //
    // Since this uses guessIcon under, it can find loosely matching icons.
    function guessFromList(names: list<string>): string {
        for (let i = 0; i < names.length; i++) {
            let guess = guessIcon(names[i]);
            // we found a match, woohoo
            if (guess)
                return Quickshell.iconPath(guess);
        }

        // nothing I guess.
        return "";
    }

    // Check whether an icon with the given name exists.
    function iconExists(iconName) {
        if (!iconName || iconName.length == 0)
            return false;
        return (Quickshell.iconPath(iconName, true).length > 0) && !iconName.includes("image-missing");
    }

    // Tries to (sloppily) guess app icons based on an arbitrary string.
    //
    // It tries the substitutions set above (normal and regex), and tries todo a sloppy/heuristic
    // lookup in the desktop entries to find the `Icon=` property of it. If all fails, returns
    // null
    //
    // This function is copied and modified from Ardox's Sleex, thank you very much!
    function guessIcon(str) {
        if (!str || str.length == 0)
            return "";

        // Normal substitutions
        if (substitutions[str])
            return substitutions[str];
        // Regex substitutions
        for (let i = 0; i < regexSubstitutions.length; i++) {
            const substitution = regexSubstitutions[i];
            const replacedName = str.replace(substitution.regex, substitution.replace);
            if (replacedName != str) {
                return replacedName;
            }
        }

        // If it gets detected normally, no need to guess
        if (iconExists(str))
            return str;

        let guessStr = str;
        // Guess: Take only app name of reverse domain name notation
        guessStr = str.split('.').slice(-1)[0].toLowerCase();
        if (iconExists(guessStr))
            return guessStr;
        // Guess: normalize to kebab case
        guessStr = str.toLowerCase().replace(/\s+/g, "-");
        if (iconExists(guessStr))
            return guessStr;

        // Guess: Use desktop entry heuristic lookup
        let desktopEntry = DesktopEntries.heuristicLookup(guessStr);
        if (desktopEntry && desktopEntry.icon !== "")
            return desktopEntry.icon;

        // Give up
        return null;
    }
}
