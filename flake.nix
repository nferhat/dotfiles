{
  description = "nferhat's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My own compositor, distributed as a flake!
    fht-compositor = {
      url = "github:nferhat/fht-compositor";

      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      # Disable rust-overlay since it's only meant to be here for the devShell provided
      # (IE. only for developement purposes, end users don't care)
      inputs.rust-overlay.follows = "";
    };
    fht-compositor-qml-plugin = {
      url = "github:/nferhat/fht-compositor-ipc-qml-plugin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Shell, for the desktop.
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Using for better command-not-found, since I don't use channels.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Using git since stable packaged in Nixpkgs is broken
    zed = {
      url = "github:zed-industries/zed";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    # Stupid games that require secureboot to work. Still good to have though.
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./hosts ./packages];

      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [git alejandra nixd];
          name = "system-config";
        };
        formatter = pkgs.alejandra;
      };
    };

  nixConfig = {
    extra-substituters = [
      # high priority since it's almost always used
      "https://cache.nixos.org?priority=10"
      "https://nix-community.cachix.org"
      "https://zed.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
