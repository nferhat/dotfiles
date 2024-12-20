{
  config,
  lib,
  pkgs,
  ...
}: {
  # NOTE: Don't use `programs.tmux` since I manage my configuration myself.
  home.packages = [pkgs.tmux];
  # xdg.configFile = {
  #   "tmux/tmux.conf" = {
  #     enable = true;
  #     source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/config/tmux/tmux.conf";
  #   };

  #   "tmux/colors.conf" = {
  #     enable = true;
  #     text = let
  #       toTmuxColorStr = attrs:
  #         lib.concatStringsSep "\n" (
  #           lib.mapAttrsToList (n: v: "set -g @${n} \"#${v}\"") attrs
  #         );
  #     in ''
  #       ${toTmuxColorStr config.theme.colors}
  #       ${toTmuxColorStr config.theme.material.colors}
  #     '';
  #   };
  # };
}
