{lib, ...}: {
  # Correct signing key.
  nferhat.programs.git.settings.user.signingkey = lib.mkForce "AE74298EEE2DD3EC";
  nferhat.programs.fht-compositor.settings.gesturebinds = {
    "focus-next-workspace" = {
      fingers = 3;
      direction = "left";
      min-swipe-distance = 1;
    };
    "focus-previous-workspace" = {
      fingers = 3;
      direction = "right";
      min-swipe-distance = 1;
    };
    "fullscreen-focused-window" = {
      fingers = 3;
      direction = "up";
    };
  };
}
