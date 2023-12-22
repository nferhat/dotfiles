{
  config,
  pkgs,
  ...
}: {
  # NOTE: Don't use `programs.tmux` since I manage my configuration myself.
  home.packages = [pkgs.tmux];
  xdg.configFile."tmux/tmux.conf" = {
    enable = true;
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/config/tmux.conf";
  };
  # TODO: not rely on this
  xdg.configFile."tmux/colors.conf" = {
    enable = true;
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/config/colors.conf";
  };
}
