{
  config,
  inputs',
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment = {
    defaultPackages = []; # can be removed safely based on the manual.
    pathsToLink = ["/share/zsh"]; # for zsh completion provided by packages.
    systemPackages = with pkgs; [
      # The base of the base, required for everyway work in the terminal
      inputs'.helix-fork.packages.default
      ripgrep
      fd
      coreutils
      wget
      curl
      cached-nix-shell

      # Archiving utilities, always useful.
      gnutar
      rar
      unrar
      zip
      unzip
      p7zip
    ];
  };

  programs = {
    less.enable = true;
    git.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

  nix = {
    # Cool trick copied from github:fufexan/dotfiles.
    # Pins the registry and sets the old $NIX_PATH for compatibility with old tooling.
    registry = lib.mapAttrs (_: flake: {inherit flake;}) inputs;
    nixPath = lib.mapAttrsToList (flake: _: "${flake}=flake:${flake}") config.nix.registry;

    settings = {
      auto-optimise-store = false; # I'd rather do this manually.
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";
      trusted-users = ["root" "@wheel"];

      substituters = [
        "https://ghostty.cachix.org"
      ];
      trusted-public-keys = [
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
    };
  };

  # TODO: pick unfree packages and add them to an unfree predicate?
  # This would be better than allowing any unfree package to pass through.
  nixpkgs.config.allowUnfree = true;
}
