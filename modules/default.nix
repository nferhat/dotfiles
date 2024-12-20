{inputs, ...}: {
  # Module re-exports only for my usage in configurations.
  # TODO: Maybe move these to hosts/shared
  flake.nixosModules = {
    core = import ./nixos/core.nix;
    desktop = import ./nixos/desktop.nix;
    user = import ./nixos/user.nix;
  };
}
