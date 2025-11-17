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
    ./halloy.nix
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
    qbittorrent
    imagemagick

    # Wayland utilities for the graphical session.
    grim
    slurp
    wl-clipboard
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
