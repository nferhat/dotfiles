{lib, ...}: {
  programs.fish = {
    enable = true;
    preferAbbrs = true;

    interactiveShellInit = ''
      set fish_greeting # disable welcome greeting as I don't need it.
      fish_vi_key_bindings # enable vi-like binds
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStringsSep "$" [
        " $directory" # needs $ otherwise doesn't work
        "git_branch"
        "git_metrics"
        "jobs"
        "nix_shell"
        "cmd_duration"
        "character"
      ];

      git_metrics.disabled = false;

      nix_shell = {
        symbol = "";
        impure_msg = "!";
        pure_msg = "";
        format = "[|](237) [$symbol $state$name]($style) ";
      };

      directory = {
        style = "blue";
        truncation_length = 5;
      };

      character = {
        success_symbol = "[|>](237)";
        error_symbol = "[!>](red)";
        vimcmd_symbol = "[<|](cyan)";
        vimcmd_visual_symbol = "[<|](yellow)";
        vimcmd_replace_symbol = "[<|](red)";
      };

      git_branch = {
        format = "[|](237) [$symbol(:$remote_branch)]($style) $branch ";
        symbol = "";
      };

      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[|](237) [$duration]($style) ";
        style = "yellow";
      };
    };
  };

  xdg.configFile."fish/themes/fht.theme".text = with import ../../theme; ''
    fish_color_normal ${text.primary}
    fish_color_command ${ansi.color4}
    fish_color_param ${ansi.color3}
    fish_color_option ${ansi.color3}
    fish_color_keyword ${ansi.color5}
    fish_color_quote ${ansi.color2}
    fish_color_redirection ${ansi.color1}
    fish_color_end ${ansi.color5}
    fish_color_comment ${text.tertiary} '--italics'
    fish_color_error ${error}
    fish_color_gray ${text.secondary}
    fish_color_selection --background=${ansi-bright.color8}
    fish_color_search_match --background=${ansi-bright.color8} --foreground=${ansi.color0}
    fish_color_operator ${ansi.color1}
    fish_color_escape ${ansi.color1}
    fish_color_autosuggestion ${text.tertiary}
    fish_color_cancel ${ansi.color5}
    fish_color_status ${info}
    fish_pager_color_progress ${text.tertiary} '--italics'
    fish_pager_color_prefix ${ansi.color4} '--bold'
    fish_pager_color_completion ${text.primary}
    fish_pager_color_description ${text.secondary} '--italics'
  '';

  # Make enableFishIntegration options enabled by default.
  # This will also generate aliases from home.aliases
  home.shell.enableFishIntegration = true;
}
