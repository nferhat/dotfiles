pkgs: {
  mons = let
    mons-unwrapped = pkgs.callPackage ./mons.nix {};
  in
    pkgs.buildFHSEnv {
      name = "mons";
      runScript = "${mons-unwrapped}/bin/mons";
      targetPkgs = pkgs: [pkgs.curl pkgs.glib pkgs.icu pkgs.openssl];
    };

  # Up-to-date version of it. Nixpkgs is still on 25.10
  arashi-icon-theme = pkgs.callPackage ./arashi-icon-theme.nix {};

  # Nice-looking music player.
  meloville = pkgs.callPackage ./meloville.nix {};

  # v2.0.0, not packaged in nix (anything beyond 1.0.0 isn't)
  lsfg-vk = pkgs.callPackage ./lsfg-vk/cli.nix {};

  # Custom Iosevka variant, based on Zed fonts.
  #
  # We manually pin the Iosevka source since I don't care about updating to the latest, and I will
  # not find any differences (I'd pay you a thousand bucks if you could)
  fht-mono = pkgs.callPackage ./fht-mono {};
}
