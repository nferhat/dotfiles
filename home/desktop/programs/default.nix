{
  self,
  pkgs,
  inputs',
  inputs,
  ...
}: {
  imports = [
    # I keep around two editors at once.
    # Zed for most of my tasks, and Helix in case I am in a TTY.
    ./zed.nix
    ./wofi.nix
    ./ghostty.nix
    ./games.nix
    ./adw-steam.nix
    inputs.zen-browser.homeModules.twilight
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
