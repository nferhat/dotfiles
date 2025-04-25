{...}: {
  programs.zed-editor = {
    enable = true;
    userSettings = {
      # Disable most of the AI junk that I don't need nor rely on.
      features = {
        copilot = true;
      };
      assistant = {
        enabled = true;
        button = true;
        version = 1;
      };
      notification_panel.button = false;

      # Clean up the UI, since by default its very much influenced by VSCode and is
      # very, very, crammed.
      tab_bar = {show_nav_history_buttons = false;};
      scrollbar.show = "never";
      buffer_line_height = "standard"; # makes line more similar to a terminal
      outline_panel.button = false;
      # By disabling everything in the toolbar, it hides it.
      toolbar = {
        selections_menu = false;
        breadcrumbs = false;
        quick_actions = false;
      };

      # Just some changes to the terminal. notably enable it to find Nerd Fonts.
      terminal = {
        shell.program = "fish";
        toolbar.breadcrumbs = false;
        font_fallbacks = ["Iosevka Nerd Font"];
        line_height = "standard";
      };

      # General behaviour settings. I am very used to this coming from vim/helix
      search.regex = true;
      use_smartcase_search = true;
      vim_mode = true; # NEEDED.
      inlay_hints.enabled = true; # By default you must enable it per-buffer.
      diagnostics = {
        include_warnings = true;
        inline.enable = true;
      };

      # UI changes to my liking.
      file_finder.modal_max_width = "medium";
      ui_font_size = 16;
      buffer_font_size = 16;
      ui_font_family = "Fht Mono";
      buffer_font_family = "Fht Term";
      theme = {
        mode = "system";
        light = "fht";
        dark = "fht";
      };
      project_panel = {
        button = true;
        indent_size = 24;
      };
      indent_guides = {
        line_width = 2;
        active_line_width = 2;
        coloring = "fixed";
      };
    };

    userKeymaps = [
      # Default stuff that applies everywhere.
      # Carrying muscle memory from vim+tmux+helix+whatever
      {
        context = "GitPanel || ProjectPanel || CollabPanel || OutlinePanel || ChatPanel || VimControl || EmptyPane || SharedScreen || MarkdownPreview || KeyContextView";
        bindings = {
          # Disable newfile.
          "ctrl-n" = null;
          # Disable select all.
          "ctrl-a" = null;
          # Tab controls similar to what I had in tmux
          "ctrl-a n" = "tab_switcher::Toggle";
          "ctrl-a p" = ["tab_switcher::Toggle" {select_last = true;}];

          # Other stuff to mimic my previous configs
          "space e" = "workspace::ToggleLeftDock";
          "space ," = "command_palette::Toggle";
          "space shift-t" = "workspace::NewCenterTerminal";
          "space t" = "workspace::NewTerminal";
          "space w" = ["workspace::SendKeystrokes" "ctrl-w"];
          "space x" = ["pane::CloseActiveItem" {close_pinned = true;}];
          "space --" = "pane::SplitDown";
          "space |" = "pane::SplitRight";
          "space /" = "pane::DeploySearch";
          "space f" = "file_finder::Toggle";
        };
      }

      {
        context = "Workspace || Editor";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-j" = "workspace::ActivatePaneDown";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-l" = "workspace::ActivatePaneRight";
          # Some muscle memory from tmux/helix
          "ctrl-a --" = "pane::SplitDown";
          "ctrl-a |" = "pane::SplitRight";
          "ctrl-a c" = ["pane::CloseActiveItem" {close_pinned = true;}];
          # Much better than tab switcher.
          "ctrl-tab" = "pane::ActivateNextItem";
          "ctrl-shift-tab" = "pane::ActivatePrevItem";
        };
      }

      {
        context = "vim_mode == normal";
        bindings = {
          "space s" = "workspace::Save";
          "g /" = null; # replaced by Space-/
          "space k" = "editor::Hover";
          "space a" = "editor::ToggleCodeActions";
          "space r" = "editor::Rename";
          "space R" = "editor::FindAllReferences";
          "space d" = "editor::GoToDiagnostic";
          "space c" = "vim::ToggleComments";
          "ctrl-c" = "vim::ToggleComments";
          "m m" = "vim::Matching";
          # Do not make me use two keys.
          ">" = ["workspace::SendKeystrokes" "> >"];
          "<" = ["workspace::SendKeystrokes" "< <"];
          # Some muscle memory I still have from using helix for like 1+ year.
          "g e" = "vim::EndOfDocument";
          "%" = "editor::SelectAll";
        };
      }

      {
        # When inside the tab switcher, make it behave like tmux.
        #
        # In tmux, after hitting the initial Ctrl-A {N/P}, you can hit N/P multiple
        # times to re-do the same action. Very useful
        context = "TabSwitcher";
        bindings = {
          "p" = "menu::SelectPrevious";
          "n" = "menu::SelectNext";
        };
      }
      {
        # Idem when inside a menu
        context = "Picker || menu";
        bindings = {
          "p" = "menu::SelectPrevious";
          "n" = "menu::SelectNext";
        };
      }


      {
        context = "Editor && vim_mode == insert";
        bindings = {
          # Better signature help, from my neovim configs.
          "ctrl-k" = "editor::ShowSignatureHelp";
        };
      }

      {
        context = "vim_mode == visual";
        bindings = {
          # Keep selection when doing some visual actions
          "ctrl-c" = ["workspace::SendKeystrokes" "g c g v"];
          ">" = ["workspace::SendKeystrokes" "> g v"];
          "<" = ["workspace::SendKeystrokes" "< g v"];
          # Muscle memory from helix
          "s" = ["workspace::SendKeystrokes" ": s /"];
        };
      }
    ];
  };

  xdg.configFile."zed/themes/fht.json" = {
    text = let
      theme = import ../../../theme;
      values = {
        name = "fht";
        author = "Nadjib Ferhat";
        themes = [
          (with theme; {
            name = "fht";
            appearance = "dark";
            style = {
              # This is the window background.
              # Setting it to blurred doesn't do anything on Linux except making it transparent.
              "background.appearance" = "blurred";
              "background" = "#${background.primary}e8";

              # Main editor UI.
              "editor.gutter.background" = "#00000000";
              "editor.document_highlight.read_background" = "#${background.secondary}";
              "editor.document_highlight.write_background" = "#${background.tertiary}";
              "editor.document_highlight.bracket_background" = "${ansi.color4}80";
              "editor.foreground" = "#${text.primary}";
              "editor.background" = "#00000000";
              "editor.line_number" = "#${text.tertiary}b0";
              "editor.active_line_number" = "#${ansi.color4}";
              "editor.active_line.background" = "#${background.tertiary}a0";
              "editor.indent_guide" = "#${separator}4f";
              "editor.indent_guide_active" = "#${separator}";
              "panel.indent_guide" = "#${separator}";
              "search.match_background" = "#${ansi.color3}";
              "toolbar.background" = "#00000000";
              "scrollbar.thumb.background" = "#${separator}";
              "status_bar.background" = "#${background.tertiary}f0";
              "title_bar.background" = "#${background.tertiary}f0";
              "title_bar.inactive_background" = "#${background.tertiary}f0";
              "tab_bar.background" = "#00000000";
              "tab.active_background" = "#${accent}09";
              "tab.inactive_background" = "#00000000";
              "drop_target.background" = "#${ansi.color4}20";
              "panel.background" = "#${background.primary}20"; # for panels like git/project panel
              "panel" = "#${text.primary}";
              "link_text.hover" = "#${ansi.color4}";
              # Surfaces --- Popups and stuff
              "surface.background" = "#${ansi-bright.color8}";
              "elevated_surface.background" = "#${background.secondary}";
              # Elements --- the buildings blocks of the UI.
              "element.background" = "#${background.secondary}b0";
              "element.hover" = "#${background.secondary}d0";
              "element.selected" = "#${background.secondary}f0";
              # Borders are just around different panes/windows/buffers.
              "border" = "#${separator}";
              "border.focused" = "#${accent}7f";
              "border.active" = "#${accent}7f";

              # Text and Icons
              "text" = "#${text.primary}";
              "text.muted" = "#${ansi.color7}a0";
              "text.disabled" = "#${text.tertiary}";
              "text.accent" = "#${accent}";
              "text.placeholder" = "#${text.tertiary}";
              "icon.muted" = "#${ansi.color7}";
              "icon.disabled" = "#${text.tertiary}";
              "icon.accent" = "#${accent}";
              "icon.placeholder" = "#${text.tertiary}";

              # Diff
              created = "#${ansi.color2}";
              added = "#${ansi.color2}";
              "version_control.added" = "#${ansi.color2}1f";
              modified = "#${ansi.color4}";
              "version_control.modified" = "#${ansi.color4}1f";
              deleted = "#${ansi.color1}";
              "version_control.deleted" = "#${ansi.color1}1f";
              "conflict.background" = "#${ansi.color1}7f";

              # Diagnostics.
              error = "#${ansi.color1}";
              "error.border" = "#${ansi.color1}";
              warning = "#${ansi.color3}";
              "warning.border" = "#${ansi.color3}";
              info = "#${ansi.color4}";
              "info.border" = "#${ansi.color4}";
              hint = "#${text.tertiary}";
              "hint.border" = "#00000000";
              success = "#${ansi.color2}";
              "success.border " = "#${ansi.color2}";

              # --- Use the same background for all the diagnostics.
              "error.background" = "#${background.secondary}";
              "warning.background" = "#${background.secondary}";
              "info.background" = "#${background.secondary}";
              "hint.background" = "#${background.secondary}";
              "success.background" = "#${background.secondary}";

              # Terminal colors.
              "terminal.background" = "#00000000";
              "terminal.foreground" = "#${text.primary}";
              "terminal.ansi.black" = "#${ansi.color0}";
              "terminal.ansi.red" = "#${ansi.color1}";
              "terminal.ansi.green" = "#${ansi.color2}";
              "terminal.ansi.yellow" = "#${ansi.color3}";
              "terminal.ansi.blue" = "#${ansi.color4}";
              "terminal.ansi.magenta" = "#${ansi.color5}";
              "terminal.ansi.cyan" = "#${ansi.color6}";
              "terminal.ansi.white" = "#${ansi.color7}";
              # --- bright variations
              "terminal.ansi.bright_black" = "#${ansi-bright.color8}";
              "terminal.ansi.bright_red" = "#${ansi-bright.color9}";
              "terminal.ansi.bright_green" = "#${ansi-bright.color10}";
              "terminal.ansi.bright_yellow" = "#${ansi-bright.color11}";
              "terminal.ansi.bright_blue" = "#${ansi-bright.color12}";
              "terminal.ansi.bright_magenta" = "#${ansi-bright.color13}";
              "terminal.ansi.bright_cyan" = "#${ansi-bright.color14}";
              "terminal.ansi.bright_white" = "#${ansi-bright.color15}";

              syntax = {
                "attribute".color = "#${ansi.color3}";
                "constructor".color = "#${ansi.color3}";
                "type".color = "#${ansi-bright.color11}";
                "type.builtin".color = "#${ansi.color3}";
                "type.parameter".color = "#${ansi.color3}";
                "boolean".color = "#${ansi.color3}";
                "constant".color = "#${ansi.color3}";
                "number".color = "#${ansi.color3}";
                "constant.builtin".color = "#${ansi-bright.color11}";
                "constant.character".color = "#${ansi.color1}";
                "string".color = "#${ansi.color2}";
                "string.regexp".color = "#${ansi.color3}";
                "string.special".color = "#${ansi.color1}";
                "comment" = {
                  color = "#${text.tertiary}";
                  "font_style" = "italic";
                };
                "identifier".color = "#${ansi.color1}";
                "variable".color = "#${text.primary}";
                "variable.special".color = "#${ansi.color6}";
                "variant".color = "#${ansi-bright.color11}";
                "label".color = "#${ansi.color3}"; # rust lifetimes
                "punctuation".color = "#${ansi.color1}";
                "keyword".color = "#${ansi.color5}";
                "keyword.control.import".color = "#${ansi.color4}";
                "keyword.operator".color = "#${ansi.color1}";
                "keyword.storage.modifier".color = "#${ansi-bright.color11}";
                "operator".color = "#${ansi.color1}";
                "function".color = "#${ansi.color4}";
                "function.macro".color = "#${ansi.color1}";
                "tag".color = "#${ansi.color3}";
                "namespace".color = "#${ansi.color1}";
                "special".color = "#${ansi.color1}";
                "link_uri".color = "#6791c9";
                "link_text".color = "#df5b61";
              };
            };
          })
        ];
      };
    in
      builtins.toJSON values;
  };
}
