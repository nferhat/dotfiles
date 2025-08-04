# Setup my user + home-manager for it, on a NixOS config
{
  self',
  self,
  lib,
  inputs,
  inputs',
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  # Keep bash as the login shell.
  # For my terminal emulator it starts up fish, same with tmux.
  users.users."nferhat" = {
    description = "Nadjib Ferhat";
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "input"];
    initialPassword = "nixos"; # don't forget to change it!
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit self' self inputs inputs';
      # Also include home-manager lib otherwise hyprland flake no build
      lib = lib.extend (self: _: {inherit (inputs.home-manager.lib) hm;});
    };
    users."nferhat" = import ../../home/nferhat.nix;
  };
}
