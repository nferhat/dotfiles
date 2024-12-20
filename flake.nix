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

    # Custom helix fork with PR awaiting to merge (helix-editor/helix#12151)
    # Otherwise this won't load the configuration properly.
    helix-fork = {
      url = "github:nferhat/helix/feat/completion-item-kinds";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./hosts ./modules ./home ./packages];

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
