.pragma library
// Configuration for the bar and different modules of it.
// Sadly, due to me being lazy, there are no presets to make it vertical.

// Configuration for the bar window.
var bar = {
  // The size of the bar.
  size: 50,
  // Margin around the components of the bar.
  margin: 6,
  // Spacing between the components of the bar,
  spacing: 6
}

// Configuration for the clock module.
var clock = {
  // Whether to show shorthand weather information. If enabled, a small icon with the current temperature
  // will be shown next to the clock.
  showWeather: true
}

// Configuration for the workspaces indicator.
var workspaces = {
  // Margins around the workspace indicators.
  margin: 4,
  // Whether to show numbers in empty workspaces. If this is set to false it will use
  // dots instead.
  showWorkspaceNumbers: true,

  icons: {
    // Whether to show app icons of the active window in each respective workspace.
    // If disabled it will just highlight the square.
    show: true,
    // The size of the icon
    size: 16,
  },

  // Configuration for the active pill below the workspace.
  activePill: {
    // The height of the active pill.
    height: 3,
    // The width of the active pill relative to a workspace indicator.
    // Range is in [0-1] inclusive, multiplied by the width of the indicator
    width: 0.5
  },
}

// Configuration of the mini-player module.
var player = {
  // Whether to show which player (as an app icon) is playing the media.
  // Falls back to a generic Material Icon if the app icon couldn't be found.
  showPlayerIcon: true,

  progress: {
    // Whether to show time progress.
    show: true,
    // Whether to show total time
    showTotal: true,
  },
}
