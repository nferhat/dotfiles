# Setup my user + home-manager for it, on a NixOS config
{
  pkgs,
  inputs,
  inputs',
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  users.users."nferhat" = {
    description = "Nadjib Ferhat";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager"];
    initialPassword = "nixos"; # don't forget to change it!
  };

  # tldr: without this zsh will not work and I won't be able to login to my user
  programs.zsh.enable = true;
  environment.variables.ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs inputs';};
    users."nferhat" = import ../../home/nferhat.nix;
  };
}
