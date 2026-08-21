pkgs: {
  mons = let
    mons-unwrapped = pkgs.callPackage ./mons.nix {};
  in
    pkgs.buildFHSEnv {
      name = "mons";
      runScript = "${mons-unwrapped}/bin/mons";
      targetPkgs = pkgs: [pkgs.curl pkgs.glib pkgs.icu pkgs.openssl];
    };

  # Custom font variations. Based on Adwaita Sans and Zed Mono
  zed-mono = pkgs.iosevka.override {
    privateBuildPlan = builtins.readFile ./zed-mono.toml;
    set = "ZedMono";
  };
  zed-term = pkgs.iosevka.override {
    privateBuildPlan = builtins.readFile ./zed-mono.toml;
    set = "ZedTerm";
  };

  # Up-to-date version of it. Nixpkgs is still on 25.10
  arashi-icon-theme = pkgs.callPackage ./arashi-icon-theme.nix {};

  # Nice-looking music player.
  meloville = pkgs.callPackage ./meloville.nix {};

  # Up-to-date versions of both.
  lsfg-vk = pkgs.callPackage ./lsfg-vk.nix {};
  # lsfg-vk-ui = pkgs.callPackage ./lsfg-vk-ui.nix {};
}
