{inputs', ...}: {
  programs.helix = {
    enable = true;
    package = inputs'.helix-editor.packages.default;
    defaultEditor = true;

    settings = {
      theme = "fht";
      editor = {
        color-modes = true;
        popup-border = "none";
        line-number = "relative";
        auto-completion = false; # I prefer manual completion.
        inline-diagnostics.cursor-line = "warning";
        rulers = [80 100];

        indent-guides = {
          render = true;
          character = "▎";
        };

        smart-tab = {
          enable = true;
          supersede-menu = false;
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

    themes."fht" = let
      theme = import ../../theme;
      # inherit (theme) ansi ansi-bright background text;
      addColorHashtag = builtins.mapAttrs (_: value: "#" + value);
      ansi = addColorHashtag theme.ansi;
      ansi-bright = addColorHashtag theme.ansi-bright;
      background = addColorHashtag theme.background;
      text = addColorHashtag theme.text;
      separator = "#" + theme.separator;
    in {
      "attribute" = ansi.color3;
      "constructor" = ansi.color3;
      "type" = "color11";
      "type.builtin" = ansi.color3;
      "type.parameter" = ansi.color3;
      "constant" = ansi.color3;
      "constant.builtin" = ansi-bright.color11;
      "constant.character" = ansi.color1;
      "string" = ansi.color2;
      "string.regexp" = ansi.color1;
      "string.special.url" = ansi.color4;
      "comment" = { fg = text.tertiary; modifiers = ["italic"]; };
      "variable" = text.primary;
      "variable.builtin" = ansi.color6;
      "label" = ansi.color3; # rust lifetimes
      "punctuation" = ansi.color1;
      "keyword" = ansi.color5;
      "keyword.control.import" = ansi.color4;
      # "keyword.operator" = ansi.color1;
      "keyword.storage.modifier" = ansi-bright.color11;
      "operator" = ansi.color1;
      "function" = ansi.color4;
      "function.macro" = ansi.color1;
      "tag" = ansi.color3;
      "namespace" = ansi.color1;
      "special" = ansi.color1;
      "markup.heading.marker" = ansi.color1;
      "markup.list" = ansi.color1;
      "markup.bold" = { fg = ansi.color1; modifiers = ["bold"]; };
      "markup.italic" = { modifiers = ["italic"]; };
      "markup.strikethrough" = { fg = text.primary; modifiers = ["crossed_out"]; };
      "markup.link.url" = ansi.color4;
      "markup.link.label" = ansi.color1;
      "markup.link.text" = ansi.color1;
      "markup.quote" = text.secondary;
      "diff.plus" = ansi.color3;
      "diff.minus" = ansi.color1;
      "diff.delta" = ansi.color2;

      # Completion interface
      "markup.normal" = ansi.color1;
      "markup.heading" = ansi.color4;
      "markup.raw" = text.primary;

      # UI
      "ui.background" = { fg = "text"; };
      "ui.background.separator" = separator;
      "ui.window" = "separator";
      "ui.cursor" = { bg = ansi.color4; fg = ansi.color0; };
      "ui.cursor.normal" = { fg = ansi.color1; bg = ansi.color0; };
      "ui.cursor.insert" = { fg = ansi.color4; bg = ansi.color0; };
      "ui.cursor.select" = { fg = ansi.color3; bg = ansi.color0; };
      "ui.debug.breakpoint" = ansi.color1;
      "ui.debug.active" = ansi.color1;
      "ui.linenr" = text.tertiary;
      "ui.linenr.selected" = { fg = ansi.color4; modifiers = ["bold"]; };
      "ui.statusline.normal" = ansi.color1;
      "ui.statusline.insert" = ansi.color4;
      "ui.statusline.select" = ansi.color3;
      "ui.statusline.separator" = "separator";
      "ui.popup" = { bg = background.tertiary; };
      "ui.popup.info" = { bg = background.tertiary; };
      "ui.help".bg = background.secondary;
      "ui.text" = text.primary;
      "ui.text.directory" = ansi.color4;
      "ui.text.focus" = { fg = ansi.color4; modifiers = ["bold"]; };
      "ui.text.inactive" = text.tertiary;
      "ui.text.info" = ansi.color4;
      "ui.virtual.ruler".bg = background.secondary;
      "ui.virtual.wrap" = text.tertiary;
      "ui.virtual.indent-guide" = separator;
      "ui.virtual.inlay-hint" = text.tertiary;
      "ui.selection".bg = ansi-bright.color8;
      "ui.highlight".bg = ansi.color0;
      "tabstop".bg = ansi-bright.color8; # snippet placeholder

      # telescope-like picker
      "ui.picker.header" = ansi-bright.color11;
      "ui.picker.header.column".bg = background.secondary;
      "ui.picker.header.column.active" = ansi-bright.color8;

      # statusline
      "ui.statusline".bg = background.tertiary;

      # Completion menu
      "ui.menu".bg = background.tertiary;
      "ui.menu.selected" = { bg = ansi.color0; fg = ansi.color4; modifiers = ["bold"]; };
      "ui.menu.scroll" = { fg = separator; bg = ansi.color0; };

      # Diagnostics
      "hint" = text.tertiary;
      "info" = ansi.color6;
      "warning" = ansi.color3;
      "error" = ansi.color1;
      "diagnostic.hint".underline = { color = text.tertiary; style = "line"; };
      "diagnostic.info".underline = { color  = text.tertiary; style = "line"; };
      "diagnostic.warning".underline = { color = ansi.color3; style = "line"; };
      "diagnostic.error".underline = { color = ansi.color1; style = "line"; };
      "diagnostic.unnecessary" = text.tertiary;
      "diagnostic.depretaced".modifiers = ["crossed_out"];
    };
  };
}
