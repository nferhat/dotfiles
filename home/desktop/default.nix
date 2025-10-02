{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./fht-compositor.nix
    ./services.nix
    ./quickshell.nix
    ./gtk-theme.nix
  ];

  home = {
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland"; # run Celeste natively.
      XDG_SESSION_TYPE = "wayland";
      # NixOS wrappers use this variable to automatically set required flags for electron applications
      # to run with ozone support (and thus running natively)
      NIXOS_OZONE_WL = "1";
    };

    pointerCursor = {
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
      package = pkgs.vimix-cursors;
      name = "Vimix-cursors";
      size = 24;
    };
  };

  # Required so that other programs can find out about fonts installed by the NixOS system
  # configuration and the ones installed with `home.packages`
  fonts.fontconfig.enable = true;

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  # TODO: Swap it out with fht-notify when I come around and actually write it
  # This is going to be very annoying...
  services.mako.enable = true;

  xresources.path = "${config.xdg.configHome}/Xresources";
}
