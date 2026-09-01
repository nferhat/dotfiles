{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./fht-compositor.nix
    ./music.nix
    ./games.nix
    ./ghostty.nix
    ./gtk.nix
    ./halloy.nix
    ./quickshell.nix
    ./services.nix
  ];

  home = {
    packages = with pkgs; [
      # GUI applications
      keepassxc
      telegram-desktop
      fractal
      loupe
      qbittorrent
      imagemagick
      vesktop
      dino

      # Nice degoogled-chromium browser.
      inputs.helium.packages."${pkgs.system}".default

      # Wayland utilities for the graphical session.
      grim
      slurp
      wl-clipboard
      wlr-randr
    ];

    sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland,x11"; # run Celeste natively.
      XDG_SESSION_TYPE = "wayland";
      # NixOS wrappers use this variable to automatically set required flags for electron applications
      # to run with ozone support (and thus running natively)
      NIXOS_OZONE_WL = "1";
      # qtengine for theming qt stuff
      QT_QPA_PLATFORMTHEME = "qtengine";
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
      plugins = with pkgs.obs-studio-plugins; [obs-vaapi obs-vkcapture wlrobs];
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
    platformTheme.name = null;
  };

  xresources.path = "${config.xdg.configHome}/Xresources";
}
