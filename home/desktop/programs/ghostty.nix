{
  inputs',
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = inputs'.ghostty.packages.default;
    settings = let
      theme = import ../../../theme;
      ansiColors = theme.ansi // theme.ansi-bright;
      palette = lib.genList (i: let
        colorValue = ansiColors."color${toString i}";
      in "${toString i}=${colorValue}")
      15;
    in {
      command = "fish";
      font-family = "Iosevka"; # term has fixed-length characters
      font-size = 10;
      cursor-style = "block";
      cursor-style-blink = false;
      window-decoration = false;
      desktop-notifications = false; # annoying
      auto-update = "off";
      window-padding-balance = true;
      adjust-box-thickness = 1;
      adjust-underline-thickness = 1;
      window-padding-x = 5;
      window-padding-y = 5;
      font-feature = "-calt, -liga, -dlig";
      window-inherit-working-directory = false;
      # The heuristics to detected if ghostty should enable/disable this are not supported in
      # fht-compositor, so we force this on instead.
      gtk-single-instance = true;
      # This does not really matter since all the serious work I do is under a tmux session
      # Closing a terminal does not close the server.
      confirm-close-surface = false;

      # Optionally load dank-material-shell colors
      config-file = "?./config-colors";

      # Theme, directly ported from alacritty.
      background-opacity-cells = true;
      background = theme.background.primary;
      background-opacity = 0.95;
      foreground = theme.text.primary;
      inherit palette;
    };
  };
}
