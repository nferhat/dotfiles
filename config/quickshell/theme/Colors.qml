pragma Singleton

import QtQuick
import Quickshell

// theme/default.nix -*- Theme variable for this flake.
//
// They are just personal preference, meant to mesh together terminal environments and GUI applications
// that I develop (using fht-iced) beautifully (according to my subjective opinion, of course)
//
// The actual theme variable list is derived from structure Theme, defined in `src/lib.rs` of
// github:nferhat/fht-iced, that I use for my projects to develop the Fht desktop environment.
//
// Regarding the **values**, they are a cross match between many themes, the main ones that I recall
// are:
// - github:rxyhn/yoru theme
// - NvChad's onedarker (onedark variation)
// - Zed's onedark varation
// - Some random dude that had a cool rice on bspwm, I forgot his name...
// - Colors generated from a random osu! map background (for accents and backgrounds) using
//    Google's material colors generator
//
// NOTE: The colors do NOT include a hashtag since some programs except just a raw hex value.
Singleton {
    // Terminal colors
    property QtObject ansi: QtObject {
        property color color0: "#141617"
        property color color1: "#df5b61"
        property color color2: "#87c7a1"
        property color color3: "#de8f78"
        property color color4: "#6791c9"
        property color color5: "#bc83e3"
        property color color6: "#70b9cc"
        property color color7: "#c4c4c4"
    }

    // Bright terminal colors, usually used for bold, or some variation in a TUI.
    property QtObject ansi_bright: QtObject {
        property color color8: "#181819"
        property color color9: "#ee6a70"
        property color color10: "#96d6b0"
        property color color11: "#ffb29b"
        property color color12: "#7ba5dd"
        property color color13: "#cb92f2"
        property color color14: "#7fc8db"
        property color color15: "#cccccc"
    }

    // Background and text colors, arranged into palletes of three variations
    //
    // - The primary color is the main color, used for large areas/text fields, for example your
    //   terminal background should use background.primary
    //
    // - The secondary color is used for less important UI elements  that should indicate updates or
    //   new information to the user, and may require user interaction.
    //
    // - The tertiary color, used for miscellaneous UI elements that should not distract the user's
    //   main interaction with the other part of the UI. It can also be used to create contrast with the
    //   secondary UI color.
    //   For example, your comments in the text editor should be highlighted using text.tertiary. The
    //   statusline of your editor should be highlighted using background.tertiary
    property QtObject background: QtObject {
        property color primary: "#101012"
        property color secondary: "#141416"
        property color tertiary: "#0c0d10"
    }
    property QtObject text: QtObject {
        property color primary: "#efefef"
        property color secondary: "#c4c6d0"
        property color tertiary: "#53536a"
    }

    // The accent color for important text.
    property color accent: ansi.color4

    // The text color4 for error messages.
    // You'd generally pair this with background.secondary to make the error pop out.
    property color error: "#df5b61"

    // The text color for warning messages.
    // You'd generally pair this with background.secondary to make the warning pop out.
    property color warning: "#de8f78"

    // The text color for information messages.
    property color info: "#87c7a1"

    // The color for separators of UI elements, or borders around areas.
    // For example a popup border in the UI should use separator.
    property color separator: "#222224"
}
