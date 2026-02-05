pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property var iconCache: ({})

    function getCachedIcon(str) {
        if (!str)
            return "image-missing";
        if (iconCache[str])
            return iconCache[str];

        const result = guessIcon(str);
        iconCache[str] = result;
        return result;
    }

    function iconExists(iconName) {
        return (Quickshell.iconPath(iconName, true).length > 0) && !iconName.includes("image-missing");
    }

    // Validate icon and return fallback if needed
    function validateIcon(iconName) {
        if (!iconName || iconName.length === 0) {
            return "image-missing";
        }

        // If it's an absolute path, check if file exists
        if (iconName.startsWith("/")) {
            // Use Quickshell.iconPath to check if the path is valid
            const resolvedPath = Quickshell.iconPath(iconName, true);
            if (resolvedPath.length === 0) {
                return "image-missing";
            }
            return iconName;
        }

        // For icon names (not paths), check if they exist in the theme
        if (iconExists(iconName)) {
            return iconName;
        }

        return "image-missing";
    }

    function getIconFromDesktopEntry(className) {
        if (!className || className.length === 0)
            return null;

        const normalizedClassName = className.toLowerCase();

        for (let i = 0; i < list.length; i++) {
            const app = list[i];
            if (app.command && app.command.length > 0) {
                const executableLower = app.command[0].toLowerCase();
                if (executableLower === normalizedClassName) {
                    return app.icon || "application-x-executable";
                }
            }
            if (app.name && app.name.toLowerCase() === normalizedClassName) {
                return app.icon || "application-x-executable";
            }
            if (app.keywords && app.keywords.length > 0) {
                for (let j = 0; j < app.keywords.length; j++) {
                    if (app.keywords[j].toLowerCase() === normalizedClassName) {
                        return app.icon || "application-x-executable";
                    }
                }
            }
        }
        return null;
    }

    function guessIcon(str) {
        if (!str || str.length == 0)
            return "image-missing";

        const desktopIcon = getIconFromDesktopEntry(str);
        if (desktopIcon)
            return desktopIcon;

        if (substitutions[str])
            return substitutions[str];

        for (let i = 0; i < regexSubstitutions.length; i++) {
            const substitution = regexSubstitutions[i];
            const replacedName = str.replace(substitution.regex, substitution.replace);
            if (replacedName != str)
                return replacedName;
        }

        if (iconExists(str))
            return str;

        const extensionGuess = str.split('.').pop().toLowerCase();
        if (iconExists(extensionGuess))
            return extensionGuess;

        const dashedGuess = str.toLowerCase().replace(/\s+/g, "-");
        if (iconExists(dashedGuess))
            return dashedGuess;

        return str;
    }

    property var substitutions: ({
            "Librewolf": "librewolf",
            "code-url-handler": "visual-studio-code",
            "Code": "visual-studio-code",
            "gnome-tweaks": "org.gnome.tweaks",
            "pavucontrol-qt": "pavucontrol",
            "wps": "wps-office2019-kprometheus",
            "wpsoffice": "wps-office2019-kprometheus",
            "footclient": "foot",
            "zen": "zen-browser"
        })
    property list<var> regexSubstitutions: [
        {
            "regex": /^steam_app_(\d+)$/,
            "replace": "steam_icon_$1"
        },
        {
            "regex": /Minecraft.*/,
            "replace": "minecraft"
        },
        {
            "regex": /.*polkit.*/,
            "replace": "system-lock-screen"
        },
        {
            "regex": /gcr.prompter/,
            "replace": "system-lock-screen"
        }
    ]

    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values).sort((a, b) => a.name.localeCompare(b.name))

    // Index structure: [{ name: "lower", command: "lower", keywords: ["lower"], original: appObject }, ...]
    property var searchIndex: []

    function buildIndex() {
        const newIndex = [];
        for (let i = 0; i < list.length; i++) {
            const app = list[i];
            newIndex.push({
                name: app.name.toLowerCase(),
                command: (app.command && app.command.length > 0) ? app.command.join(' ').toLowerCase() : "",
                executable: (app.command && app.command.length > 0) ? app.command[0].toLowerCase() : "",
                comment: (app.comment || "").toLowerCase(),
                genericName: (app.genericName || "").toLowerCase(),
                keywords: (app.keywords || []).map(k => k.toLowerCase()),
                original: app
            });
        }
        searchIndex = newIndex;
    }

    property var allAppsCache: null

    function invalidateCache() {
        allAppsCache = null;
    }

    onListChanged: {
        allAppsCache = null;
        buildIndex();
    }

    Component.onCompleted: {
        buildIndex();
        // Pre-build cache in background if possible, or just wait for first access
    }
}
