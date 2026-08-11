{
  description = "nferhat's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My own compositor, distributed as a flake!
    fht-compositor = {
      url = "github:nferhat/fht-compositor";

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

    # Better browser.
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages."${system}";
  in {
    nixosConfigurations = import ./hosts inputs;
    packages."${system}" = import ./packages pkgs;
    devShells."${system}".default = pkgs.mkShell {
      packages = with pkgs; [git alejandra nixd];
      name = "system-config";
    };
  };
}
