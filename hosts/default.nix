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
    inherit (inputs.nixpkgs) lib;
    sharedModules = [
      self.nixosModules.core
      self.nixosModules.user
    ];
  in {
    # Host naming conventions: use all lowercase model name, with shorthands if possible.
    # Example: "Helwett-Packard da0018-nk" -> "hp-da0018nk"

    hp-da0018nk = lib.nixosSystem {
      specialArgs = {inherit inputs inputs';};
      modules = [./hp-da0018nk self.nixosModules.desktop] ++ sharedModules;
    };
  });
}
