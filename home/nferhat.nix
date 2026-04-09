{
  lib,
  pkgs,
  config,
  osConfig,
  inputs,
  ...
}: {
  imports = let
    hasHostConfig = builtins.pathExists ./${osConfig.networking.hostName};
    hostConfig = lib.optional hasHostConfig ./${osConfig.networking.hostName};
  in
    [
      ./desktop
      ./session.nix
      ./services.nix
      # Program configuration. This is the core of my setup.
      ./helix.nix
      ./tmux.nix
      ./fish.nix
      ./git.nix
      # Use the pre-made database.
      inputs.nix-index-database.homeModules.default
    ]
    ++ hostConfig;

  home = {
    stateVersion = "23.11";
    username = "nferhat";
    homeDirectory = "/home/nferhat";
  };

  # Modularize some stuff since I don't need everything in the streamer session.
  # I don't want to create a whole configuraiton framework, just some basic toggles.
  fht.desktop = {
    halloy.enable = true;
    games.enable = true;
  };
}
