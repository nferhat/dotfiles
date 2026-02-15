{
  config,
  inputs',
  ...
}: {
  home.packages = [
    inputs'.quickshell.packages.default
    inputs'.fht-compositor-qml-plugin.packages.default
  ];
  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink "/home/nferhat/Documents/repos/personal/dotfiles/config/quickshell";
  # FIXME: Generate Colors.qml
}
