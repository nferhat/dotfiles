{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./browser
    ./fht-compositor.nix
    ./games.nix
    ./ghostty.nix
    ./gtk.nix
    ./halloy.nix
    ./quickshell.nix
    ./services.nix
    ./vicinae.nix
    ./zed.nix
  ];

  home = {
    packages = with pkgs; [
      # GUI applications
      nautilus
      overskride
      remmina
      gnome-secrets
      telegram-desktop
      fractal
      pwvucontrol
      loupe
      vesktop
      icon-library
      mission-center
      gtklock
      bustle
      qbittorrent
      imagemagick

      # Wayland utilities for the graphical session.
      grim
      slurp
      wl-clipboard
    ];

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
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 32;
    };
  };

  programs = {
    zathura.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [obs-vaapi obs-vkcapture];
    };

    mpv = {
      enable = true;
      # TODO: Theme ModernZ
      scripts = with pkgs.mpvScripts; [thumbfast modernz mpris];
    };
  };

  # Required so that other programs can find out about fonts installed by the NixOS system
  # configuration and the ones installed with `home.packages`
  fonts.fontconfig = {
    enable = true;
    # Additional tweaking to make font rendering look nice.
    subpixelRendering = "rgb";
    antialiasing = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  # TODO: Swap it out with fht-notify when I come around and actually write it
  # This is going to be very annoying...
  services.mako.enable = true;

  xresources.path = "${config.xdg.configHome}/Xresources";
}
