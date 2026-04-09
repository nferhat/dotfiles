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
    stateVersion = "26.05";
    username = "streamer";
    homeDirectory = "/home/streamer";
  };

  fht.desktop = {
    # No need for my IRC client nor games to be installed in this session.
    halloy.enable = false;
    games.enable = false;
  };
}
