{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = builtins.readFile ../../config/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [sensible yank copycat];
  };

  xdg.configFile.tmux-theme = {
    target = "tmux/colors.conf";
    text = let
      theme = import ../../theme;
    in ''
      set -g @color0 "#${theme.ansi.color0}"
      set -g @color1 "#${theme.ansi.color1}"
      set -g @color2 "#${theme.ansi.color2}"
      set -g @color3 "#${theme.ansi.color3}"
      set -g @color4 "#${theme.ansi.color4}"
      set -g @color5 "#${theme.ansi.color5}"
      set -g @color6 "#${theme.ansi.color6}"
      set -g @color7 "#${theme.ansi.color7}"
      set -g @color8 "#${theme.ansi-bright.color8}"
      set -g @color9 "#${theme.ansi-bright.color9}"
      set -g @color10 "#${theme.ansi-bright.color10}"
      set -g @color11 "#${theme.ansi-bright.color11}"
      set -g @color12 "#${theme.ansi-bright.color12}"
      set -g @color13 "#${theme.ansi-bright.color13}"
      set -g @color14 "#${theme.ansi-bright.color14}"
      set -g @color15 "#${theme.ansi-bright.color15}"
      set -g @background_primary "#${theme.background.primary}"
      set -g @background_secondary "#${theme.background.secondary}"
      set -g @background_tertiary "#${theme.background.tertiary}"
      set -g @text_primary "#${theme.text.primary}"
      set -g @text_secondary "#${theme.text.secondary}"
      set -g @text_tertiary "#${theme.text.tertiary}"
      set -g @accent "#${theme.accent}"
      set -g @error "#${theme.error}"
      set -g @warning "#${theme.warning}"
      set -g @info "#${theme.info}"
      set -g @separator "#${theme.separator}"
    '';
  };
}
