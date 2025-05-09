{lib, ...}: {
  programs.fht-compositor.settings = {
    general = {
      # Allow for more gaps since we have more screen real estate
      outer-gaps = lib.mkForce 30;
      inner-gaps = lib.mkForce 15;
    };

    # Max out resolution and framerate on main display
    # FIXME: Currently fht-compositor errors out with out-of-memory if you try
    # to start the compositor with a high refresh rate. I modeset to 180hz when the session starts.
    outputs.DP-1.mode = "2560x1440@60";
  };

  # I was too bothered to move over the key.
  # Plus, the old one didn't have my student e-mail, which I would prefer.
  # programs.git.extraConfig.user.signingkey = "F8AC8C6E4C9D6A0C";

  # Yeah, 24 is way too small
  home.pointerCursor.size = lib.mkForce 32;
  # 10 is adequate for the tiny 1366x768 screen I had on hp-da0018nk
  programs.ghostty.settings.font-size = 13;
}
