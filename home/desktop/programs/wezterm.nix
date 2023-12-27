{config, ...}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    # Colorscheme in sync with the rice
    # Using a premade one even if the one in the rice is matching
    # will not copy one to one what I like, soo.
    colorSchemes."rice" = let
      ansiColors = builtins.mapAttrs (_: c: "#" + c) config.theme.colors;
      materialColors = builtins.mapAttrs (_: c: "#" + c) config.theme.material.colors;
    in {
      ansi = with ansiColors; [
        color0
        color1
        color2
        color3
        color4
        color5
        color6
        color7
      ];
      brights = with ansiColors; [
        color8
        color9
        color10
        color11
        color12
        color13
        color14
        color15
      ];

      background = materialColors.surface;
      foreground = materialColors.on_surface;
      selection_bg = materialColors.surface_container;
      cursor_bg = materialColors.primary;
    };

    extraConfig = ''
      local wezterm = require("wezterm");
      local C = wezterm.config_builder() or {}

      C.font_size = 10
      C.anti_alias_custom_block_glyphs = false
      C.font = wezterm.font_with_fallback({
          "Iosevka",
          "Iosevka Nerd Font",
          "codicon",
      })
      C.harfbuzz_features = {
          "ss12", -- Ubuntu mono general style
          "cv89=1", -- Curvy six
          "cv92=1", -- Curvy nine
          "cv94=1", -- Curvy comma/semicolon
          "cv97=3", -- Very low underscore
          "cv83=2", -- Pretty zero
          "VLAA=2",
          "VLAB=2",
          "VLAC=2",
          "VLAD=2",
          "VLAE=2",
          "VLAF=2",
      }
      C.underline_position = "125%"
      C.underline_thickness = "2px"

      C.color_scheme = "rice";
      C.enable_scroll_bar = false
      C.enable_tab_bar = false

      C.exit_behavior = "Close"
      C.window_close_confirmation = "NeverPrompt"

      return C
    '';
  };
}
