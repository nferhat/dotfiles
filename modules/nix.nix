{
  config,
  lib,
  inputs,
  ...
}: {
  nix = {
    # Cool trick copied from github:fufexan/dotfiles.
    # Pins the registry and sets the old $NIX_PATH for compatibility with old tooling.
    registry = lib.mapAttrs (_: flake: {inherit flake;}) inputs;
    nixPath = lib.mapAttrsToList (flake: _: "${flake}=flake:${flake}") config.nix.registry;

    settings = {
      auto-optimise-store = false; # I'd rather do this manually.
      use-xdg-base-directories = true;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";
      trusted-users = ["root" "@wheel"];

      substituters = [
        # high priority since it's almost always used
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # TODO: pick unfree packages and add them to an unfree predicate?
  # This would be better than allowing any unfree package to pass through.
  nixpkgs.config.allowUnfree = true;
}
