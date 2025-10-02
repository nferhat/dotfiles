{
  lib,
  pkgs,
  ...
}: {
  programs.fht-compositor.settings = {
    general = {
      # Allow for more gaps since we have more screen real estate
      outer-gaps = lib.mkForce 30;
      inner-gaps = lib.mkForce 15;
    };

    # Max out resolution and framerate on main display
    outputs.DP-3.mode = "2560x1440@180";
    # See window rules in fht-compositor.nix
    outputs.DP-3.vrr = "on-demand";
  };

  # I was too bothered to move over the key.
  # Plus, the old one didn't have my student e-mail, which I would prefer.
  # programs.git.extraConfig.user.signingkey = "F8AC8C6E4C9D6A0C";
  programs.git.extraConfig.user.signingkey = lib.mkForce "AE74298EEE2DD3EC";

  # Yeah, 24 is way too small
  home.pointerCursor.size = lib.mkForce 32;
  # 10 is adequate for the tiny 1366x768 screen I had on hp-da0018nk
  programs.ghostty.settings.font-size = 13;

  home.packages = with pkgs; [
    # I do some gaming on this very capable machine
    ryubing
  ];
}
