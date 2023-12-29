{pkgs, ...}: {
  imports = [./wofi.nix ./wezterm.nix];
  home.packages = with pkgs; [
    # GUI applications
    wofi
    mpv
    pcmanfm
    keepassxc
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    # Wayland utilities for the graphical session.
    grim
    slurp
    wl-clipboard
    wlr-randr
    wl-screenrec
  ];

  programs = {
    librewolf.enable = true;
  };
}
