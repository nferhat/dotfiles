{
  self,
  inputs,
  lib,
  ...
}:
# home.nix -*- setup my user and home-manager with it.
#
# I don't use home-manager as a separate CLI. Instead, home-manager is deployed as part of my system
# configuration, which makes it straightforward to manage my dotfiles as a whole.
{
  imports = [
    inputs.home-manager.nixosModules.default
    # sets up an alias, `nferhat.*` to `home-manager.users.nferhat.*`, allowing me to access
    # all of the home-manager options fairly quickly without trouble.
    (lib.mkAliasOptionModule ["nferhat"] ["home-manager" "users" "nferhat"])
  ];

  users.users."nferhat" = {
    # NOTE: I keep the login shell as bash on purpose to avoid breakage
    # my terminal emulator it starts up fish, which is the shell I use (same with tmux)
    description = "Nadjib Ferhat";
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "input"];
    initialPassword = "nixos"; # don't forget to change it!
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit self inputs;};
    users."nferhat" = {
      # Set these and never touch them again.
      home = {
        stateVersion = "23.11";
        username = "nferhat";
        homeDirectory = "/home/nferhat";
      };
    };
    # users."nferhat" = import ../../home/nferhat.nix;
  };
}
