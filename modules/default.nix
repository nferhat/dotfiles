{inputs, ...}: {
  flake.nixosModules = {
    core = import ./nixos/core.nix;
    desktop = import ./nixos/desktop.nix;
    user = import ./nixos/user.nix;
    theme = import ./theme inputs.material-colors-generator;
  };

  flake.homeManagerModules = rec {
    theme = import ./theme inputs.material-colors-generator;
    default = theme;
  };
}
