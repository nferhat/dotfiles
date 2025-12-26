{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Addicted till the end of my life
    # You never quit osu, they say.
    osu-lazer-bin
    # Not a GUI but it's a CLI for celeste mod management.
    #
    # FIXME: Currently broken, complains about tkinter not building, tommath?
    # Idk, too bothered to fix it + I play celeste on windows and manage mods from there for now
    # self'.packages.mons
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
      font_file = "${pkgs.iosevka}/share/fonts/truetype/Iosevka-Regular.ttf";
      gamemode = true;
      wine = true;
      vulkan_driver = true;
    };
  };
}
