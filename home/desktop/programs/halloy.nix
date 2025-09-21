{...}: {
  programs.halloy = {
    enable = true;

    settings = {
      theme = "fht";
      font = {
        family = "Fht Mono";
        size = 16;
      };
      servers."liberachat" = {
        server = "irc.libera.chat";
        nickname = "nferhat";
        realname = "Nadjib Ferhat";
        channels = ["#rust" "#rust-windowing" "#smithay" "#hare" "#wgpu"];
      };
      # Make the client behave as a "single-pane", IE no splits or anything.
      # I find them annoying.
      actions.sidebar.buffer = "replace-pane";
      actions.buffer = {
        click_channel_name = "replace-pane";
        click_highlight = "replace-pane";
        click_username = "replace-pane";
        local = "replace-pane";
        message_channel = "replace-pane";
        message_user = "replace-pane";
      };
    };

    themes."fht" = let
      theme = import ../../../theme;
    in rec {
      general = {
        background = "#${theme.background.primary}";
        border = "#${theme.separator}";
        horizontal_rule = "#${theme.separator}";
        unread_indicator = "#${theme.ansi-bright.color11}";
      };

      text = {
        primary = "#${theme.text.primary}";
        secondary = "#${theme.text.secondary}";
        tertiary = "#${theme.text.tertiary}";
        success = "#${theme.ansi.color2}";
        error = "#${theme.error}";
      };

      buffer = {
        action = "#${theme.accent}";
        background = "#${theme.background.secondary}";
        background_text_input = "#${theme.background.tertiary}7f";
        background_title_bar = "#${theme.background.tertiary}7f";
        border = "#${theme.separator}";
        border_selected = "#${theme.accent}";
        code = "#${theme.background.secondary}";
        highlight = "#${theme.ansi-bright.color8}";
        nickname = "#${theme.ansi.color2}";
        selection = "#${theme.background.secondary}";
        timestamp = "#${theme.ansi.color3}";
        topic = "#${theme.ansi.color2}";
        url = "#${theme.ansi.color4}";
        server_messages = {
          join = "#${theme.text.tertiary}";
          quit = "#${theme.text.tertiary}";
          change_host = "#${theme.ansi.color3}";
          change_mode = "#${theme.ansi.color2}";
          change_nick = "#${theme.text.tertiary}";
          reply_topic = "#${theme.accent}";
          default = "#${theme.text.secondary}";
        };
      };

      buttons.primary = {
        background = "#00000000";
        background_hover = "#${theme.background.secondary}";
        background_selected = "#${theme.ansi.color0}";
        background_selected_hover = "#${theme.ansi-bright.color8}";
      };

      buttons.secondary = buttons.primary;
    };
  };
}
