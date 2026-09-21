{
  config,
  self,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./fht-compositor.nix
    ./fonts.nix
    ./ghostty.nix
    ./gtk.nix
    ./qt.nix
    ./quickshell.nix
    ./services.nix
  ];

  users.users.nferhat.packages = with pkgs; [
    # GUI applications
    keepassxc
    telegram-desktop
    fractal
    imv
    qbittorrent
    imagemagick
    vesktop
    dino
    piper
    zathura

    # Nice degoogled-chromium browser.
    inputs.helium.packages."${pkgs.system}".default

    # Music setup. Nothing particularly special about this.
    # Amberol is fine, but I wanna write my mpd client at some point...
    self.packages."${pkgs.system}".meloville
    picard

    # Wayland utilities for the graphical session.
    grim
    slurp
    wl-clipboard
    wlr-randr
  ];

  # Set the pointer cursor theme.
  nferhat.home.pointerCursor = {
    gtk.enable = true;
    x11 = {
      enable = true;
      defaultCursor = "left_ptr";
    };
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-dark";
    size = 32;
  };

  nferhat.programs = {
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

  # fuck off my $HOME directory
  nferhat.xresources.path = "${config.nferhat.xdg.configHome}/Xresources";

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    # XDG variables setup
    # safe defaults, in case the xdg nixos module, setting them here to avoid race conditions
    # as the xdg module sets them after `environment.variables` are set.
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # Enable wayland on toolkits and whatnot
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland,x11";
    XDG_SESSION_TYPE = "wayland";
    # NixOS wrappers use this variable to automatically set required flags for electron applications
    # to run with ozone support (and thus running natively)
    NIXOS_OZONE_WL = "1";
    # qtengine for theming qt stuff
    QT_QPA_PLATFORMTHEME = "qtengine";
  };

  programs.dconf.enable = true;

  services = {
    # Needed for home-manager to apply theming values (for GTK and GN*ME stuff)
    dbus.packages = [pkgs.dconf];

    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };

    displayManager.ly = {
      enable = true;
      x11Support = false;
    };
  };

  # Depedency of pipewire.
  security.rtkit.enable = true;

  # Niceness and integration for wayland sessions
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = ["gtk"];
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
