inputs @ {
  self,
  nixpkgs,
  ...
}: let
  # Get nixpkgs library then add my own functions and stuff
  lib = nixpkgs.lib.extend (self: _: {
    fht = import ../lib/default.nix {lib = self; pkgs = nixpkgs.legacyPackages."x86_64-linux";};
  });

  inherit (lib) filterAttrs mapAttrs readDir nixosSystem;
  specialArgs = {inherit self lib inputs;};
  availableSystems = filterAttrs (_: type: type == "directory") (readDir ./.);

  mkHost = hostname: _:
    nixosSystem {
      inherit specialArgs;
      modules = [(import ./${hostname}) {networking.hostName = hostname;}];
    };
in
  mapAttrs
  mkHost
  availableSystems
