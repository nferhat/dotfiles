{
  self',
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
    ];

    # Good HUD for stats and stuff. Replaces what I don't have with AMD Adrenalin
    programs.mangohud = {
      enable = true;
      settings = {
        # ,gamemode,wine,vulkan_driver
        preset = 3;
        gpu_list = [0 1];
        fps_metrics = ["avg" "0.01"];
        fsr = true;
        gpu_fan = true;
        gpu_name = true;
        proc_vram = true;
        font_file = "${self'.packages.zed-mono}/share/fonts/truetype/IosevkaZedMono-Regular.ttf";
        gamemode = true;
        wine = true;
        vulkan_driver = true;
      };
    };
  };
}
