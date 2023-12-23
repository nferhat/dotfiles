{
  self,
  config,
  inputs,
  withSystem,
  ...
}: {
  flake.nixosConfigurations = withSystem "x86_64-linux" (ctx @ {
    config,
    inputs',
    ...
  }: let
    # Get nixpkgs library then add my own functions and stuff
    lib = inputs.nixpkgs.lib.extend (self: _: {
      fht = import ../lib/default.nix {lib = self;};
    });

    sharedModules = [
      self.nixosModules.core
      self.nixosModules.user
    ];
  in {
    # Host naming conventions: use all lowercase model name, with shorthands if possible.
    # Example: "Helwett-Packard da0018-nk" -> "hp-da0018nk"

    hp-da0018nk = lib.nixosSystem {
      specialArgs = {inherit lib inputs inputs';};
      modules = [./hp-da0018nk self.nixosModules.desktop] ++ sharedModules;
    };
  });
}
