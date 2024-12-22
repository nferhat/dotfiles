{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        ipc_socket = false; # I don't make use of it.
        live_config_reload = true;
      };

      window = {
        decorations = "None";
        dynamic_title = true;
        dynamic_padding = true;
        resize_increments = true;
      };

      font = {
        # NOTE: The NixOS system config sets the monospace font for me.
        # I don't have to worry about it here.
        size = 10;
        builtin_box_drawing = true;
      };

      cursor = {
        style = {
          shape = "block";
          blinking = "off";
        };
        thickness = 1;
      };

      colors = let
        theme = import ../../../theme;
      in {
        transparent_background_colors = true;
        draw_bold_text_with_bright_colors = false;

        primary = {
          foreground = "#${theme.text.primary}";
          background = "#${theme.background.primary}";
          dim_foreground = "#${theme.text.tertiary}";
          bright_foreground = "#${theme.ansi.color7}";
        };

        cursor = {
          cursor = "#${theme.accent}";
          text = "#${theme.ansi.color0}";
        };

        selection = {
          text = "CellForeground";
          background = "#${theme.ansi-bright.color8}";
        };

        normal = {
          black = "#${theme.ansi.color0}";
          red = "#${theme.ansi.color1}";
          green = "#${theme.ansi.color2}";
          yellow = "#${theme.ansi.color3}";
          blue = "#${theme.ansi.color4}";
          magenta = "#${theme.ansi.color5}";
          cyan = "#${theme.ansi.color6}";
          white = "#${theme.ansi.color7}";
        };

        bright = {
          black = "#${theme.ansi-bright.color8}";
          red = "#${theme.ansi-bright.color9}";
          green = "#${theme.ansi-bright.color10}";
          yellow = "#${theme.ansi-bright.color11}";
          blue = "#${theme.ansi-bright.color12}";
          magenta = "#${theme.ansi-bright.color13}";
          cyan = "#${theme.ansi-bright.color14}";
          white = "#${theme.ansi-bright.color15}";
        };
      };

      # Disable every builtin keyboard bindings.
      # I don't really care about having much in my terminal, since I use tmux.
      keyboard.bindings = [];
    };
  };
}
