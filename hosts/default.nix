{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake.nixosConfigurations = withSystem "x86_64-linux" (
    {
      inputs',
      self',
      ...
    }: let
      # Get nixpkgs library then add my own functions and stuff
      lib = inputs.nixpkgs.lib.extend (self: _: {
        fht = import ../lib/default.nix {lib = self;};
      });

      inherit (lib) filterAttrs mapAttrs readDir nixosSystem;
      specialArgs = {inherit self' self lib inputs inputs';};
      systems =
        # Filter for the shared module (doesn't have a default.nix and gets imported from
        # other hosts default.nix files), and skip on singular .nix files.
        filterAttrs (name: type: name != "shared" && type == "directory")
        # Read all directories here
        (readDir ./.);
    in
      mapAttrs
      # Then build the host using nixosSystem, setting the default hostname.
      (hostname: _:
        nixosSystem {
          inherit specialArgs;
          modules = [(import ./${hostname}) {networking.hostName = hostname;}];
        })
      systems
  );
}
