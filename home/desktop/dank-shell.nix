{
  inputs',
  inputs,
  ...
}:
# Quickshell is the shell I build my desktop UI on.
# Written in QT its really good.
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  # Currently enabling dank-material-shell to test out its features and integrate
  # it with fht-compositor, however, I will (later) write my own shell.
  programs.dankMaterialShell = {
    enable = true;

    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dankMaterialShell changes
    };

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableClipboard = true; # Clipboard history manager
    enableVPN = true; # VPN management widget
    enableBrightnessControl = true; # Backlight/brightness controls
    enableColorPicker = true; # Color picker tool
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableSystemSound = true; # System sound effects

    quickshell.package = inputs'.quickshell.packages.default;
  };
}
