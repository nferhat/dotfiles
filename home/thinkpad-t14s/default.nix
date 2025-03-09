{lib, ...}: {
  programs.fht-compositor.settings = {
    general = {
      # Allow for more gaps since we have more screen real estate
      outer-gaps = lib.mkForce 30;
      inner-gaps = lib.mkForce 15;
    };
  };

  # Yeah, 24 is way too small
  home.pointerCursor.size = lib.mkForce 48;

  # 10 is adequate for the tiny 1366x768 screen I had on hp-da0018nk
  programs.ghostty.settings.font-size = 13;
}
