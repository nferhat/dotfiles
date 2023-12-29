{
  self,
  pkgs,
  ...
}: {
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
    # Not gui but for GUI apps
    self.packages."${pkgs.system}".mons
  ];

  programs = {
    librewolf.enable = true;
  };
}
