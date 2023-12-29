{...}: {
  perSystem = {pkgs, ...}: {
    packages.mons = let
      mons-unwrapped = pkgs.callPackage ./mons.nix {};
    in
      pkgs.buildFHSUserEnv {
        name = "mons";
        runScript = "${mons-unwrapped}/bin/mons";
        targetPkgs = pkgs: [pkgs.curl pkgs.glib pkgs.icu pkgs.openssl];
      };
  };
}
