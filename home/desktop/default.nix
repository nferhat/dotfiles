{
  config,
  pkgs,
  ...
}: {
  imports = [./programs ./hyprland.nix];

  home = {
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland"; # run Celeste natively.
      XDG_SESSION_TYPE = "wayland";
    };

    pointerCursor = {
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
      package = pkgs.phinger-cursors;
      name = "Phinger";
      size = 24;
    };
  };

  # Required so that other programs can find out about fonts installed by the NixOS system
  # configuration and the ones installed with `home.packages`
  fonts.fontconfig.enable = true;

  gtk = let
    # Copied this from github:rxyhn/yuki.
    gtkPreferDarkMode = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
    };
  in {
    enable = true; # duh.
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # TODO: Figure out a theme when I write theme module
    # theme = {};

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    font = {
      name = "Inter";
      size = 10;
    };

    gtk3.extraConfig = gtkPreferDarkMode;
    gtk4.extraConfig = gtkPreferDarkMode;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  # TODO: Proper config
  services.mako.enable = true;

  xresources.path = "${config.xdg.configHome}/Xresources";
}
