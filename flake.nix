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
      url = "github:nferhat/fht-compositor/wip-screencast-persist";
      # url = "/home/nferhat/Documents/repos/personal/fht-compositor";

      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      # Disable rust-overlay since it's only meant to be here for the devShell provided
      # (IE. only for developement purposes, end users don't care)
      inputs.rust-overlay.follows = "";
    };

    # Shell, for the desktop.
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lossless frame generation
    lsfg-vk = {
      url = "github:pabloaul/lsfg-vk-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
    # Using latest versions
    # helix-editor = {
    #   # url = "github:helix-editor/helix";
    #   # Custom branch with icons
    #   url = "github:RoloEdits/helix/icons-v2";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Stupid games that require secureboot to work. Still good to have though.
    # TODO: Enable this for thinkpad-t14s, currently only setup for basement
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
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
