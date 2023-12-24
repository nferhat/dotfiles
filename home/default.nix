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
    # Get nixpkgs library then add my own functions and stuff
    lib = inputs.nixpkgs.lib.extend (self: _: {
      fht = import ../lib/default.nix {lib = self;};
      # Also include home-manager lib otherwise hyprland flake no build
      inherit (inputs.home-manager.lib) hm;
    });

    inherit (inputs.home-manager.lib) homeManagerConfiguration;
  in {
    nferhat = homeManagerConfiguration {
      modules = [./nferhat.nix];
      extraSpecialArgs = {inherit lib inputs inputs';};
      inherit pkgs;
    };
  });
}
