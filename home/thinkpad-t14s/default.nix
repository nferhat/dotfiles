{lib, ...}: {
  programs.fht-compositor.settings = {
    # This laptops gets wired up to a 2k MSI screen.
    # On the thinkpad station with the DPI port I am using it registers as DP-4 and sometimes DP-5
    # Annoying.
    outputs = rec {
      # The layout I am rocking with
      # ---
      #          +------------+
      # +-------+|    DP-4/   |
      # | eDP-1 ||    /DP-5   |
      # +-------++------------+
      eDP-1 = {
        # Always put my laptop screen at the bottom left.
        # S
        position = [0 360];
      };
      DP-4 = {
        position = [1920 0];
        # The laptop cannot output 2k above 120hz
        # And 1080 above 165, bandwidth limitation.
        mode = "2560x1440@120";
      };
      DP-5 = DP-4;
    };
  };

  # Yeah, 24 is way too small
  home.pointerCursor.size = lib.mkForce 48;

  # 10 is adequate for the tiny 1366x768 screen I had on hp-da0018nk
  programs.ghostty.settings.font-size = 13;
}
