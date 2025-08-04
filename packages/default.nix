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

      kaze-icon-theme = pkgs.callPackage ./kaze-icon-theme.nix {
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
    };
  };
}
