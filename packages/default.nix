{...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      mons = let
        mons-unwrapped = pkgs.callPackage ./mons.nix {};
      in
        pkgs.buildFHSEnv {
          name = "mons";
          runScript = "${mons-unwrapped}/bin/mons";
          targetPkgs = pkgs: [pkgs.curl pkgs.glib pkgs.icu pkgs.openssl];
        };

      arashi-icon-theme = pkgs.callPackage ./arashi-icon-theme.nix {
        inherit (pkgs.plasma5Packages) breeze-icons;
      };

      # Custom font variations. Based on Adwaita Sans and Zed Mono
      fht-mono = pkgs.iosevka.override {
        privateBuildPlan = builtins.readFile ./fht-mono.toml;
        set = "FhtMono";
      };
      fht-term = pkgs.iosevka.override {
        privateBuildPlan = builtins.readFile ./fht-mono.toml;
        set = "FhtTerm";
      };

      # Custom font variations. Based on Adwaita Sans and Zed Mono
      fht-zed-mono = pkgs.iosevka.override {
        privateBuildPlan = builtins.readFile ./fht-zed-mono.toml;
        set = "FhtZedMono";
      };
      fht-zed-term = pkgs.iosevka.override {
        privateBuildPlan = builtins.readFile ./fht-zed-mono.toml;
        set = "FhtZedTerm";
      };

      # Up-to-date versions of both.
      lsfg-vk = pkgs.callPackage ./lsfg-vk.nix {};
      # lsfg-vk-ui = pkgs.callPackage ./lsfg-vk-ui.nix {};
    };
  };
}
