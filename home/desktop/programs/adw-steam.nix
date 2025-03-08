{lib, ...}: {
  # Theme for adwaita steam, I guess
  xdg.configFile."AdwSteamGtk/custom.css".text = let
    theme = import ../../../theme;
    # gtk-colors.nix generates colors with names exactly like the GTK style
    # sheet declares them, but AdwSteam uses --adw-name-with-dashes
    rawThemeGtkColors = import ../gtk-colors.nix {
      inherit theme;
      opacity = "f0"; # about ~93% opacity
    };

    themeColors =
      lib.mapAttrs' (name: color: {
        name = builtins.replaceStrings ["color" "_"] ["rgb" "-"] name;
        value = lib.fht.color.hexToRGBA color;
      })
      rawThemeGtkColors;

    ret = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: {
      r,
      g,
      b,
      a,
    }:
      "--adw-${name}: ${toString r}, ${toString b}, ${toString g};"
      + lib.optionalString (a != 255) "\n--adw-${builtins.replaceStrings ["rgb"] ["a"] name}: ${toString (a / 255.0)};")
    themeColors);
  in ''
    :root {
      ${ret}
    }
  '';
}
