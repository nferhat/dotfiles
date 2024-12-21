{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      ipc_socket = false;
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

      colors = {
        transparent_backgrounds_colors = true;
        draw_bold_text_with_bright_colors = false;

        # TODO: Use theme values instead of setting per program.
        primary = {
          foreground = "#e3e2e8";
          background = "#101115";
          dim_foreground = "#53536a";
          bright_foreground = "#131419";
        };

        cursor = {
          cursor = "#abc4fd";
          text = "#101115";
        };

        selection = {
          text = "CellForeground";
          background = "#1c1d22";
        };

        normal = {
          black = "#14161f";
          red = "#df5b61";
          green = "#87c7a1";
          yellow = "#de8f78";
          blue = "#6791c9";
          magenta = "#bc83e3";
          cyan = "#70b9cc";
          white = "#c4c4c4";
        };

        bright = {
          black = "#222230";
          red = "#ee6a70";
          green = "#96d6b0";
          yellow = "#ffb29b";
          blue = "#7ba5dd";
          magenta = "#cb92f2";
          cyan = "#7fc8db";
          white = "#cccccc";
        };
      };

      # Disable every builtin keyboard bindings.
      # I don't really care about having much in my terminal, since I use tmux.
      keyboard.bindings = [];
    };
  };
}
