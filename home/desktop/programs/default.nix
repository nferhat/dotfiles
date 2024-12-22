{
  self,
  pkgs,
  ...
}: {
  imports = [./wofi.nix ./alacritty.nix];
  home.packages = with pkgs; [
    # GUI applications
    mpv
    pcmanfm
    keepassxc
    gnome-secrets
    fractal
    swayimg
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

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
    librewolf.enable = true;
  };
}
