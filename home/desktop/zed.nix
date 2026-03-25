{
  lib,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [zed-editor];

  xdg.configFile."zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/home/nferhat/Documents/repos/personal/dotfiles/config/zed/settings.json";
  xdg.configFile."zed/themes/fht.json" = let
    theme = import ../../theme;
    syntaxTokens = with theme;
    with theme.ansi;
    with theme.ansi-bright; {
      "attribute" = color3;
      "boolean" = color3;
      "comment" = text.tertiary;
      "constant" = color3;
      "constant.builtin" = color11;
      "constant.character" = color1;
      "constructor" = color3;
      "function" = color4;
      "function.macro" = "c4c4c4";
      "identifier" = color1;
      "keyword" = color5;
      "keyword.control.import" = color4;
      "keyword.operator" = color7;
      "keyword.storage.modifier" = color3;
      "label" = color3; # rust lifetimes
      "syntax.lifetime" = color3; # rust lifetimes
      "link_text" = color1;
      "link_uri" = color4;
      "namespace" = "606077";
      "number" = color3;
      "operator" = "606077";
      "punctuation" = "606077";
      "punctuation.bracket" = "606077";
      "punctuation.delimiter" = "606077";
      "special" = color6;
      "string" = color2;
      "string.regexp" = color1;
      "string.special" = color1;
      "tag" = color3;
      "type" = color11;
      "type.builtin" = color3;
      "type.parameter" = color3;
      "variable" = text.primary;
      "variable.special" = color7;
      "variant" = color11;
    };
    syntax = builtins.mapAttrs (_: v:
      if builtins.typeOf v == "string"
      then {color = "#${v}";}
      else v)
    syntaxTokens;

    themeTokens = with theme; {
      "background" = background.primary;
      # Main editor UI.
      "editor.foreground" = text.primary;
      "editor.background" = background.primary;
      # Gutter where the line numbers and git changes preview (per-line) are.
      "editor.gutter.background" = background.primary;
      "editor.line_number" = "${text.tertiary}7f";
      "editor.active_line_number" = ansi.color4;
      "editor.active_line.background" = "${background.tertiary}0f";
      # Document highlight, either from LSP or AI features.
      "editor.document_highlight.read_background" = background.secondary;
      "editor.document_highlight.write_background" = background.tertiary;
      "editor.document_highlight.bracket_background" = "${ansi.color4}80";
      # Indentation guides
      "editor.indent_guide" = "${separator}7f";
      "editor.indent_guide_active" = "${ansi.color7}2f";
      "panel.indent_guide" = separator;
      # Search matches.
      "search.match_background" = ansi.color3;
      "toolbar.background" = "00000000";
      # Status bar --- at the bottom, containing useful info.
      "status_bar.background" = background.tertiary;
      # Title bar --- at the top, current project + alt-buttons
      "title_bar.background" = background.tertiary;
      "title_bar.inactive_background" = background.tertiary;
      # Tab bar --- While I disable it I still theme it cause why not.
      "tab_bar.background" = background.tertiary;
      "tab.active_background" = background.primary;
      "tab.inactive_background" = "00000000";
      "drop_target.background" = "${ansi.color4}0f";
      # Panels --- sidebars that open up with content/tools.
      "panel.background" = background.tertiary; # for panels like git/project panel
      "panel" = text.primary;
      "link_text.hover" = ansi.color4;
      # Surfaces --- Popups and stuff
      "surface.background" = "${background.tertiary}";
      "elevated_surface.background" = "${background.secondary}";
      # Elements --- the buildings blocks of the UI.
      "element.background" = background.secondary;
      "element.hover" = "${background.secondary}d0";
      "element.selected" = "${background.secondary}f0";
      # Borders are just around different panes/windows/buffers.
      "border" = separator;
      "border.focused" = "${accent}7f";
      "border.active" = "${accent}7f";

      # Text and Icons
      "text" = text.primary;
      "text.muted" = "${ansi.color7}a0";
      "text.disabled" = text.tertiary;
      "text.accent" = accent;
      "text.placeholder" = text.tertiary;
      "icon.muted" = ansi.color7;
      "icon.disabled" = text.tertiary;
      "icon.accent" = accent;
      "icon.placeholder" = text.tertiary;

      # Git Diff color --- The background color gets slightly affected to look somewhat nicer.
      created = ansi.color2;
      added = ansi.color2;
      "version_control.added" = "${ansi.color2}1f";
      modified = ansi.color3;
      "version_control.modified" = "${ansi.color3}1f";
      deleted = ansi.color1;
      "version_control.deleted" = "${ansi.color1}1f";
      "conflict.background" = "${ansi.color1}1f";

      # Diagnostics.
      error = ansi.color1;
      "error.border" = ansi.color1;
      warning = ansi.color3;
      "warning.border" = ansi.color3;
      info = ansi.color4;
      "info.border" = ansi.color4;
      hint = text.tertiary;
      "hint.border" = "#00000000";
      success = ansi.color2;
      "success.border " = ansi.color2;

      # --- Use the same background for all the diagnostics.
      "error.background" = background.secondary;
      "warning.background" = background.secondary;
      "info.background" = background.secondary;
      "hint.background" = background.secondary;
      "success.background" = background.secondary;

      # Terminal colors.
      "terminal.background" = background.primary;
      "terminal.foreground" = text.primary;
      "terminal.ansi.black" = ansi.color0;
      "terminal.ansi.red" = ansi.color1;
      "terminal.ansi.green" = ansi.color2;
      "terminal.ansi.yellow" = ansi.color3;
      "terminal.ansi.blue" = ansi.color4;
      "terminal.ansi.magenta" = ansi.color5;
      "terminal.ansi.cyan" = ansi.color6;
      "terminal.ansi.white" = ansi.color7;
      # --- bright variations
      "terminal.ansi.bright_black" = ansi-bright.color8;
      "terminal.ansi.bright_red" = ansi-bright.color9;
      "terminal.ansi.bright_green" = ansi-bright.color10;
      "terminal.ansi.bright_yellow" = ansi-bright.color11;
      "terminal.ansi.bright_blue" = ansi-bright.color12;
      "terminal.ansi.bright_magenta" = ansi-bright.color13;
      "terminal.ansi.bright_cyan" = ansi-bright.color14;
      "terminal.ansi.bright_white" = ansi-bright.color15;
    };
    editorTheme = builtins.mapAttrs (_: v: "#${v}") themeTokens;
  in {
    text = builtins.toJSON {
      name = "fht";
      author = "Nadjib Ferhat";
      themes = [
        {
          name = "fht";
          appearance = "dark";
          style = editorTheme // {inherit syntax;};
        }
      ];
    };
  };
}
