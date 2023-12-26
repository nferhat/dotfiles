{pkgs, ...}: {
  imports = [./wofi.nix];
  home.packages = with pkgs; [
    # GUI applications
    wezterm
    wofi
    mpv
    pcmanfm
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
