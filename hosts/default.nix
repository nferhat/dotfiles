inputs @ {
  self,
  nixpkgs,
  ...
}: let
  # Get nixpkgs library then add my own functions and stuff
  lib = nixpkgs.lib.extend (self: _: {
    fht = import ../lib/default.nix {lib = self;};
  });

  inherit (lib) filterAttrs mapAttrs readDir nixosSystem;
  specialArgs = {inherit self lib inputs;};
  systems =
    # Filter for the shared module (doesn't have a default.nix and gets imported from
    # other hosts default.nix files), and skip on singular .nix files.
    filterAttrs (name: type: name != "shared" && type == "directory")
    # Read all directories here
    (readDir ./.);

  mkHost = hostname: _:
    nixosSystem {
      inherit specialArgs;
      modules = [(import ./${hostname}) {networking.hostName = hostname;}];
    };
in
  mapAttrs
  mkHost
  systems
