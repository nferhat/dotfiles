{
  # Most of these inputs are just to be passed down into home-manager (../../home), notably inputs and self
  # and their filtered version.
  self',
  self,
  inputs,
  inputs',
  # NixOS stuff
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  environment = {
    defaultPackages = []; # can be removed safely based on the manual.
    pathsToLink = ["/share/fish"]; # for zsh completion provided by packages.
    systemPackages = with pkgs; [
      # The base of the base, required for everyway work in the terminal
      inputs'.neovim-nightly.packages.default
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
  };

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
        "https://cache.nixos.org?priority=10"
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

  # Setup my user and the home directory.
  # Nothing special, I use home-manager as a NixOS module only, I don't make use of the home-manager utility
  # (I believe it's better to tie home configurations to system revisions)
  users.users."nferhat" = {
    # NOTE: I keep the login shell as bash on purpose, my terminal emulator it starts up fish,
    # which is the shell I use (same with tmux)
    description = "Nadjib Ferhat";
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "input"];
    initialPassword = "nixos"; # don't forget to change it!
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit self' self inputs inputs';};
    users."nferhat" = import ../../home/nferhat.nix;
  };
}
