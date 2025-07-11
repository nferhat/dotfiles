{
  self,
  pkgs,
  inputs',
  inputs,
  ...
}: {
  imports = [
    # ./zed.nix
    ./wofi.nix
    ./ghostty.nix
    ./games.nix
    ./adw-steam.nix
    ./browser
  ];
  home.packages = with pkgs; [
    # GUI applications
    nautilus
    overskride
    gnome-secrets
    telegram-desktop
    prismlauncher
    fractal
    pwvucontrol
    loupe
    vesktop
    icon-library
    mission-center
    gtklock
    bustle
    inputs'.watershot.packages.default

    # Wayland utilities for the graphical session.
    grim
    slurp
    wl-clipboard

    # Not a GUI but it's a CLI for celeste mod management.
    #
    # I cannot get olympus to work properly, unless I use a hacky flake that
    # I lost a long time ago.
    self.packages."${pkgs.system}".mons
  ];

  programs = {
    zen-browser.enable = true;
    zathura.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [obs-vaapi obs-vkcapture];
    };

    mpv = {
      enable = true;
      # TODO: Theme ModernZ
      scripts = with pkgs.mpvScripts; [thumbfast modernz];
    };
  };
}
