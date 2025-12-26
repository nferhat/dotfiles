{
  self',
  lib,
  pkgs,
  config,
  ...
}: {
  gtk = let
    # Copied this from github:rxyhn/yuki.
    gtkPreferDarkMode = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
    };
    theme = import ../../theme;

    colorsToGtkCss = colors:
      lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v:
        with lib.fht.color.hexToRGBA v;
        # NOTE: Alpha value must be between [0-1], since hexToRGBA gives values between [0-255] we divide
          "@define-color ${k} rgba(${toString r}, ${toString g}, ${toString b}, ${toString (a / 255.0)});")
      colors);

    themeColors = import ./gtk-colors.nix {
      inherit theme;
      opacity = "f0"; # about ~93% opacity
    };

    gtkThemeCss =
      colorsToGtkCss themeColors
      + "\n"
      + ''
        :root {
          --accent-bg-color: @accent_bg_color;
          --accent-fg-color: @accent_fg_color;

          --destructive-bg-color: @destructive_bg_color;
          --destructive-fg-color: @destructive_fg_color;

          --success-bg-color: @success_bg_color;
          --success-fg-color: @success_fg_color;

          --warning-bg-color: @warning_bg_color;
          --warning-fg-color: @warning_fg_color;

          --error-bg-color: @error_bg_color;
          --error-fg-color: @error_fg_color;

          --window-bg-color: @window_bg_color;
          --window-fg-color: @window_fg_color;

          --view-bg-color: @view_bg_color;
          --view-fg-color: @view_fg_color;

          --headerbar-bg-color: @headerbar_bg_color;
          --headerbar-fg-color: @headerbar_fg_color;
          --headerbar-border-color: @headerbar_border_color;
          --headerbar-backdrop-color: @headerbar_backdrop_color;
          --headerbar-shade-color: @headerbar_shade_color;
          --headerbar-darker-shade-color: @headerbar_darker_shade_color;

          --sidebar-bg-color: @sidebar_bg_color;
          --sidebar-fg-color: @sidebar_fg_color;
          --sidebar-backdrop-color: @sidebar_backdrop_color;
          --sidebar-border-color: @sidebar_border_color;
          --sidebar-shade-color: @sidebar_shade_color;

          --secondary-sidebar-bg-color: @secondary_sidebar_bg_color;
          --secondary-sidebar-fg-color: @secondary_sidebar_fg_color;
          --secondary-sidebar-backdrop-color: @secondary_sidebar_backdrop_color;
          --secondary-sidebar-border-color: @secondary_sidebar_border_color;
          --secondary-sidebar-shade-color: @secondary_sidebar_shade_color;

          --card-bg-color: @card_bg_color;
          --card-fg-color: @card_fg_color;
          --card-shade-color: @card_shade_color;

          --dialog-bg-color: @dialog_bg_color;
          --dialog-fg-color: @dialog_fg_color;

          --popover-bg-color: @popover_bg_color;
          --popover-fg-color: @popover_fg_color;
          --popover-shade-color: @popover_shade_color;

          --thumbnail-bg-color: @thumbnail_bg_color;
          --thumbnail-fg-color: @thumbnail_fg_color;

          --shade-color: @shade_color;
          --scrollbar-outline-color: @scrollbar_outline_color;

          --thumbnail-bg-color: @thumbnail_bg_color;
          --thumbnail-fg-color: @thumbnail_fg_color;
        }
      '';
  in {
    enable = true; # duh.
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # adw-gtk3 provides us with the necessary variables to edit.
    # We set them below.
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      package = self'.packages.arashi-icon-theme;
      name = "Arashi";
    };

    font = {
      name = "Inter";
      size = 10;
    };

    gtk3 = {
      extraConfig = gtkPreferDarkMode;
      extraCss = gtkThemeCss;
    };
    gtk4 = {
      extraConfig = gtkPreferDarkMode;
      extraCss = gtkThemeCss;
    };
  };
}
