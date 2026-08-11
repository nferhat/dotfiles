{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.quickshell.packages."${pkgs.system}".default
    inputs.fht-compositor-qml-plugin.packages."${pkgs.system}".default
  ];
  # xdg.configFile."quickshell".source =
  #   config.lib.file.mkOutOfStoreSymlink "/home/nferhat/Documents/repos/personal/dotfiles/config/quickshell";
  # FIXME: Generate Colors.qml
}
