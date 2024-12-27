{
  description = "nferhat's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NOTE: Not overriding nix input since I want to use the cachix they provide.
    ghostty.url = "github:ghostty-org/ghostty";

    # Custom helix fork with PR awaiting to merge (helix-editor/helix#12151)
    # Otherwise this won't load the configuration properly.
    helix-fork = {
      url = "github:nferhat/helix/feat/completion-item-kinds";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My own compositor, distributed as a flake!
    fht-compositor = {
      url = "github:nferhat/fht-compositor";
      # url = "/home/nferhat/Documents/repos/personal/fht-compositor";

      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      # Disable rust-overlay since it's only meant to be here for the devShell provided
      # (IE. only for developement purposes, end users don't care)
      inputs.rust-overlay.follows = "";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./hosts ./modules ./packages];

      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [git alejandra];
          name = "system-config";
        };
        formatter = pkgs.alejandra;
      };
    };
}
