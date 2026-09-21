{
  lib,
  pkgs,
  ...
}: {
  nferhat.programs.fht-compositor.settings = {
    # Max out resolution and framerate on main display
    outputs."DP-3" = {
      mode = "2560x1440@179.998";
      vrr = "on-demand";
    };
  };

  # Correct signing key.
  nferhat.programs.git.settings.user.signingkey = lib.mkForce "AE74298EEE2DD3EC";

  # Bigger cursor.
  nferhat.home.pointerCursor.size = lib.mkForce 16;
  # 10 is adequate for the tiny 1366x768 screen I had on hp-da0018nk
  nferhat.programs.ghostty.settings.font-size = lib.mkForce 13;

  users.users.nferhat.packages = with pkgs; [
    # Doing 3d modeling woo
    pkgsRocm.blender

    # I can actually play on this device.
    # Laptop stays strictly for work/study.
    osu-lazer-bin
    olympus
    etterna

    # Use termurin JDKs since openjdk seems to be leaking memory.
    # Why? I don't know, I was too lazy to investigate, however a fix was found on the GT:NH server.
    # Thanks lucanto.
    (prismlauncher.override {
      jdks = with javaPackages.compiler.temurin-bin; [
        jre-25
        jre-21
        jre-17
        jre-8
      ];
    })

    # To configure mangohud
    mangojuice
    protonup-qt
  ];

  # Good HUD for stats and stuff. Replaces what I don't have with AMD Adrenalin
  nferhat.programs.mangohud.enable = true;
}
