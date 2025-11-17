{config, inputs', inputs, ...}:
# Quickshell is the shell I build my desktop UI on.
# Written in QT its really good.
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.matugen.nixosModules.default
  ];

  programs.dankMaterialShell = {
    enable = true;

    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dankMaterialShell changes
    };

    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableClipboard = true;            # Clipboard history manager
    enableVPN = true;                  # VPN management widget
    enableBrightnessControl = true;    # Backlight/brightness controls
    enableColorPicker = true;          # Color picker tool
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableSystemSound = true;          # System sound effects

    quickshell.package = inputs'.quickshell.packages.default;
  };

  # Also enable matugen, since I have some custom templates to work my with neovim config (to change
  # background shades), and I have DMS configured to automatically generate the templates from it.
  programs.matugen = let
    inherit (config.xdg) configHome;
  in {
    enable = true;
    wallpaper.set = false; # DMS already handles that
    templates = {
      "fht-compositor" = {
        input_path = ./matugen/fht-compositor.toml;
        output_path = "${configHome}/fht/dank-colors.toml";
      };
      "ghostty-without-ansi" = {
        input_path = ./matugen/ghostty;
        output_path = "${configHome}/ghostty/config-colors";
      };
      "neovim-background-shades" = {
        input_path = ./matugen/neovim.lua;
        output_path = "${configHome}/theme/colors-matugen.lua";
      };
    };
  };
}
