{
  lib,
  inputs',
  config,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = inputs'.helix.packages.default;

    settings = {
      theme = "fht";
      editor = {
        color-modes = true;
        popup-border = "none";
        line-number = "relative";
        auto-completion = false; # I prefer manual completion.
        smart-tab.enable = false;
        inline-diagnostics.cursor-line = "warning";
        rulers = [80 100];

        indent-guides = {
          render = true;
          character = "▎";
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };

      # A lot of these keybinds are from helix-vim
      # Helped me a lot to get started and keep *some* of my muscle memory around
      # https://github.com/LGUG2Z/helix-vim/blob/master/config.toml
      keys.normal = {
        # Muscle memory from my neovim config
        space.s = ":write";
        space.x = ":buffer-close";
        space."|" = "vsplit";
        space.minus = "hsplit";
        space.F = "file_picker_in_current_buffer_directory";
        space.R = "goto_reference";
        # Easier window switching
        C-h = "jump_view_left";
        C-j = "jump_view_down";
        C-k = "jump_view_up";
        C-l = "jump_view_right";
        # Personal preference
        o = ["open_below" "insert_mode"];
        O = ["open_above" "insert_mode"];
        # Muscle memory
        "{" = ["goto_prev_paragraph" "collapse_selection"];
        "}" = ["goto_next_paragraph" "collapse_selection"];
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        G = "goto_file_end";
        V = ["select_mode" "extend_to_line_bounds"];
        S = "surround_add";
        # Get rid of selection when entering modes
        i = ["insert_mode" "collapse_selection"];
        a = ["append_mode" "collapse_selection"];
        # Undoing the 'd' + motion commands restores the selection which is annoying
        u = ["undo" "collapse_selection"];
        r = ["redo" "collapse_selection"];
        esc = ["collapse_selection" "keep_primary_selection"]; # this is just gold
        # Search for word under cursor
        "*" = ["move_char_right" "move_prev_word_start" "move_next_word_end" "search_selection" "search_next"];
        "#" = ["move_char_right" "move_prev_word_start" "move_next_word_end" "search_selection" "search_prev"];
        # Make j and k behave as they do Vim when soft-wrap is enabled
        j = "move_line_down";
        k = "move_line_up";
      };

      keys.insert = {
        C-x = "no_op";
        C-space = "completion";
        # Easier window switching
        C-j = "goto_next_tabstop";
        C-k = "goto_prev_tabstop";
        # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
        esc = ["collapse_selection" "normal_mode"];
      };

      keys.select = {
        # Muscle memory
        "{" = ["extend_to_line_bounds" "goto_prev_paragraph"];
        "}" = ["extend_to_line_bounds" "goto_next_paragraph"];
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        G = "goto_file_end";
        "%" = "match_brackets";
        S = "surround_add"; # Basically 99% of what I use vim-surround for
        u = ["switch_to_lowercase" "collapse_selection" "normal_mode"];
        U = ["switch_to_uppercase" "collapse_selection" "normal_mode"];
        # Visual-mode specific muscle memory
        i = "select_textobject_inner";
        a = "select_textobject_around";
        # Some extra binds to allow us to insert/append in select mode because it's nice with multiple cursors
        tab = ["insert_mode" "collapse_selection"]; # tab is read by most terminal editors as "C-i";
        C-a = ["append_mode" "collapse_selection"];

        # Make selecting lines in visual mode behave sensibly
        k = "extend_line_up";
        j = "extend_line_down";
        # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
        esc = ["collapse_selection" "keep_primary_selection" "normal_mode"];
      };
    };
  };

  xdg.configFile."helix/themes/fht.toml".text =
    ''
      "attribute" = "color3"
      "constructor" = "color3"
      "type" = "color11"
      "type.builtin" = "color3"
      "type.parameter" = "color3"
      "constant" = "color3"
      "constant.builtin" = "color11"
      "constant.character" = "color1"
      "string" = "color2"
      "string.regexp" = "color1"
      "string.special.url" = "color4"
      "comment" = { fg = "text_tertiary", modifiers = ["italic"] }
      "variable" = "text_primary"
      "variable.builtin" = "color6"
      "label" = "color3" # rust lifetimes
      "punctuation" = "color1"
      "keyword" = "color5"
      "keyword.control.import" = "color4"
      # "keyword.operator" = "color1"
      "keyword.storage.modifier" = "color11"
      "operator" = "color1"
      "function" = "color4"
      "function.macro" = "color1"
      "tag" = "color3"
      "namespace" = "color1"
      "special" = "color1"
      "markup.heading.marker" = "color1"
      "markup.list" = "color1"
      "markup.bold" = { fg = "color1", modifiers = ["bold"] }
      "markup.italic" = { modifiers = ["italic"] }
      "markup.strikethrough" = { fg = "text_primary", modifiers = ["crossed_out"] }
      "markup.link.url" = "color4"
      "markup.link.label" = "color1"
      "markup.link.text" = "color1"
      "markup.quote" = "color16"
      "diff.plus" = "color3"
      "diff.minus" = "color1"
      "diff.delta" = "color2"

      # Completion interface
      "markup.normal" = "color1"
      "markup.heading" = "color4"
      "markup.raw" = "text_primary"

      # UI
      "ui.background" = { fg = "text" }
      "ui.background.separator" = "separator"
      "ui.window" = "separator"
      "ui.cursor" = { bg = "color4", fg = "color0" }
      "ui.cursor.normal" = { bg = "color1", fg = "color0" }
      "ui.cursor.insert" = { bg = "color4", fg = "color0" }
      "ui.cursor.select" = { bg = "color3", fg = "color0" }
      "ui.debug.breakpoint" = "color1"
      "ui.debug.active" = "color1"
      "ui.linenr" = "text_tertiary"
      "ui.linenr.selected" = { fg = "color4", modifiers = ["bold"] }
      "ui.statusline.normal" = "color1"
      "ui.statusline.insert" = "color4"
      "ui.statusline.select" = "color3"
      "ui.statusline.separator" = "separator"
      "ui.popup" = { bg = "background_tertiary" }
      "ui.popup.info" = { bg = "background_tertiary" }
      "ui.help".bg = "background_secondary"
      "ui.text" = "text_primary"
      "ui.text.focus" = { fg = "color4", modifiers = ["bold"] }
      "ui.text.inactive" = "text_tertiary"
      "ui.text.info" = "color4"
      "ui.virtual.ruler".bg = "background_secondary"
      "ui.virtual.wrap" = "text_tertiary"
      "ui.virtual.indent-guide" = "separator"
      "ui.virtual.inlay-hint" = "text_tertiary"
      "ui.selection".bg = "color8"
      "ui.highlight".bg = "color0"

      # statusline
      "ui.statusline".bg = "background_tertiary"

      # Completion menu
      "ui.menu".bg = "background_tertiary"
      "ui.menu.selected" = { bg = "color0", fg = "color4", modifiers = ["bold"] }
      "ui.menu.scroll" = { fg = "separator", bg = "color0" }
      # Completion kinds
      "ui.completion.kind" = "color6"
      "ui.completion.kind.type" = "color11"
      "ui.completion.kind.snippet" = "color2"
      "ui.completion.kind.constant" = "color3"
      "ui.completion.kind.constructor" = "color4"
      "ui.completion.kind.enum" = "color3"
      "ui.completion.kind.event" = "color1"
      "ui.completion.kind.interface" = "color3"
      "ui.completion.kind.keyword" = "color5"
      "ui.completion.kind.class" = "color3"
      "ui.completion.kind.module" = "color1"
      "ui.completion.kind.operator" = "comment"
      "ui.completion.kind.type-parameter" = "color3"
      "ui.completion.kind.unit" = "color2"
      "ui.completion.kind.variable" = "color6"
      "ui.completion.kind.text" = "color6"
      "ui.completion.kind.function" = "color4"
      "ui.completion.kind.method" = "color4"
      "ui.completion.kind.property" = "color5"
      "ui.completion.kind.folder" = "#f1d068"
      "ui.completion.kind.file" = "color2"
      "ui.completion.kind.struct" = "color3"

      # Diagnostics
      "hint" = "text_tertiary"
      "info" = "color6"
      "warning" = "color3"
      "error" = "color1"
      "diagnostic.hint".underline = { color = "text_tertiary", style = "line" }
      "diagnostic.info".underline = { color  = "text_tertiary", style = "line" }
      "diagnostic.warning".underline = { color = "color3", style = "line" }
      "diagnostic.error".underline = { color = "color1", style = "line" }
      "diagnostic.unnecessary" = "text_tertiary"
      "diagnostic.depretaced".modifiers = ["crossed_out"]
    ''
    + (let
      # NOTE: For now I do it the lazy way of including the theme variables when defining the theme text
      # The "better" approach is to substitute the values directly in the string above
      theme = import ../../theme;
    in ''
      [palette]
      color0 = "#${theme.ansi.color0}"
      color1 = "#${theme.ansi.color1}"
      color2 = "#${theme.ansi.color2}"
      color3 = "#${theme.ansi.color3}"
      color4 = "#${theme.ansi.color4}"
      color5 = "#${theme.ansi.color5}"
      color6 = "#${theme.ansi.color6}"
      color7 = "#${theme.ansi.color7}"

      color8  = "#${theme.ansi-bright.color8}"
      color9  = "#${theme.ansi-bright.color9}"
      color10 = "#${theme.ansi-bright.color10}"
      color11 = "#${theme.ansi-bright.color11}"
      color12 = "#${theme.ansi-bright.color12}"
      color13 = "#${theme.ansi-bright.color13}"
      color14 = "#${theme.ansi-bright.color14}"
      color15 = "#${theme.ansi-bright.color15}"

      background_primary   = "#${theme.background.primary}"
      background_secondary = "#${theme.background.secondary}"
      background_tertiary  = "#${theme.background.tertiary}"
      text_primary         = "#${theme.text.primary}"
      text_secondary       = "#${theme.text.secondary}"
      text_tertiary        = "#${theme.text.tertiary}"
      accent               = "#${theme.accent}"
      error                = "#${theme.error}"
      warning              = "#${theme.warning}"
      info                 = "#${theme.info}"
      separator            = "#${theme.separator}"
    '');
}
