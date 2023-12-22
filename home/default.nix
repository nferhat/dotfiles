{
  inputs,
  withSystem,
  ...
}: {
  flake.homeManagerConfigurations = withSystem "x86_64-linux" (ctx @ {
    pkgs,
    inputs',
    ...
  }: let
    inherit (inputs.home-manager.lib) homeManagerConfiguration;
  in {
    nferhat = homeManagerConfiguration {
      modules = [./nferhat.nix];
      extraSpecialArgs = {inherit inputs inputs';};
      inherit pkgs;
    };
  });
}
