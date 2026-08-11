{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fht.desktop.games;
in {
  options.fht.desktop.games = {
    enable = lib.mkEnableOption "Games managed by home-manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
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

      # Setting up environments easier.
      bottles

      # To configure mangohud
      mangojuice
      protonup-qt
    ];

    # Good HUD for stats and stuff. Replaces what I don't have with AMD Adrenalin
    programs.mangohud.enable = true;
  };
}
