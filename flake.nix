{
  description = "nferhat's system configuration";

  inputs = {
    # NOTE: Using a specific revision of the nixpkgs flake since there's some wonky stuff
    # hapenning with the latest version of amdgpu drivers
    nixpkgs.url = "github:NixOS/nixpkgs/d89fc19e405cb2d55ce7cc114356846a0ee5e956";
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
      # url = "/home/nferhat/Documents/repos/personal/fht-compositor";

      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      # Disable rust-overlay since it's only meant to be here for the devShell provided
      # (IE. only for developement purposes, end users don't care)
      inputs.rust-overlay.follows = "";
    };

    # Using git since stable packaged in Nixpkgs is broken
    watershot = {
      url = "github:Kirottu/watershot/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Not available in nixpkgs
    zen-browser = {
      url = "github:hengvvang/zen-browser";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # Stupid games that require secureboot to work. Still good to have though.
    # TODO: Enable this for thinkpad-t14s, currently only setup for basement
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./hosts ./modules ./packages];

      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [git alejandra nixd];
          name = "system-config";
        };
        formatter = pkgs.alejandra;
      };
    };
}
