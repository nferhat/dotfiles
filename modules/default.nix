{...}: {
  flake.nixosModules = {
    core = import ./nixos/core.nix;
    desktop = import ./nixos/desktop.nix;
    user = import ./nixos/user.nix;
    theme = import ./theme.nix;
  };
}
