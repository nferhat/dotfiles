{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = builtins.readFile ../../config/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [sensible yank copycat];
  };

  # TODO: Manage all colors in my system using a global theme.
  xdg.configFile.tmux-theme = {
    target = "tmux/colors.conf";
    text = ''
      set -g @color0 "#141617"
      set -g @color1 "#df5b61"
      set -g @color2 "#87c7a1"
      set -g @color3 "#de8f78"
      set -g @color4 "#6791c9"
      set -g @color5 "#bc83e3"
      set -g @color6 "#70b9cc"
      set -g @color7 "#c4c4c4"
      set -g @color8 "#222224"
      set -g @color9 "#ee6a70"
      set -g @color10 "#96d6b0"
      set -g @color11 "#ffb29b"
      set -g @color12 "#7ba5dd"
      set -g @color13 "#cb92f2"
      set -g @color14 "#7fc8db"
      set -g @color15 "#cccccc"
      set -g @background_primary "#101012"
      set -g @background_secondary "#141416"
      set -g @background_tertiary "#0b0c0f"
      set -g @text_primary "#efefef"
      set -g @text_secondary "#c4c6d0"
      set -g @text_tertiary "#53536a"
      set -g @accent "#6791c9"
      set -g @error "#df5b61"
      set -g @warning "#de8f78"
      set -g @info "#87c7a1"
      set -g @separator "#222224"
    '';
  };
}
