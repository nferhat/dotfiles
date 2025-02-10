{lib, ...}: {
  programs.fht-compositor.settings = {
    general = {
      # Allow for more gaps since we have more screen real estate
      outer-gaps = lib.mkForce 30;
      inner-gaps = lib.mkForce 15;
    };
  };

  # Yeah, 24 is way too small
  home.pointerCursor.size = lib.mkForce 48;

  # FIXME: Avoid copying all of this? I just want a bigger font
  # What would be better is having such generator included with ghostty flake upstream.
  xdg.configFile.ghostty-config = lib.mkForce {
    target = "ghostty/config";
    text = let
      generateConfig = values:
        builtins.concatStringsSep "\n" (lib.mapAttrsToList (key: value: "${key}=${
            if value == false
            then "false"
            else if value == true
            then "true"
            else builtins.toString value
          }")
          values);
      theme = import ../../theme;

      values = {
        font-family = "Fht Mono";
        font-size = 13;
        cursor-style = "block";
        cursor-style-blink = false;
        window-decoration = false;
        bold-is-bright = false;
        desktop-notifications = false; # annoying
        auto-update = "off";
        window-padding-balance = true;
        adjust-box-thickness = 1;
        # The heuristics to detected if ghostty should enable/disable this are not supported in
        # fht-compositor, so we force this on instead.
        gtk-single-instance = true;
        # This does not really matter since all the serious work I do is under a tmux session
        # Closing a terminal does not close the server.
        confirm-close-surface = false;

        # Theme, directly ported from alacritty.
        background = theme.background.primary;
        background-opacity = 0.93;
        foreground = theme.text.primary;
      };

      # In the https://www.ditig.com/publications/256-colors-cheat-sheet
      # ansi colors come before their bright variant.
      allAnsiPalette = theme.ansi // theme.ansi-bright;
      palleteValues = builtins.listToAttrs (
        builtins.map (idx: {
          name = "palette=${builtins.toString idx}";
          value = allAnsiPalette."color${builtins.toString idx}";
        })
        [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]
      );
    in
      generateConfig (values // palleteValues);
  };
}
