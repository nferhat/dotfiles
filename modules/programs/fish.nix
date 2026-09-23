{lib, ...}: {
  # Link the shell completions from packages for fish to find
  environment.pathsToLink = ["/share/fish"];

  # Configure fish ONLY for my user.
  #
  # And not as a login shell. My terminal emulator and multiplexer will load it. Otherwise, I use
  # plain /bin/bash for the rest, notably to avoid breakage.
  #
  # If /bin/sh or your default shell is set to anything that's not compatible with POSIX sh or bash,
  # you will suffer great pain and head slamming, scripts wont work as you expect, stuff doesn't run,
  # ...
  nferhat = {
    # Make enableFishIntegration options enabled by default.
    # This will also generate aliases from home.aliases
    home.shell.enableFishIntegration = true;

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        fish_vi_key_bindings
      '';
    };

    # Fancy prompt. Nothing special.
    # Mostly removed everything. I don't even care about the rust version ngl.
    programs.starship = {
      enable = true;

      settings = {
        format = lib.concatStringsSep "$" [
          "$directory" # needs $ otherwise doesn't work
          "git_branch"
          "git_metrics"
          "jobs"
          "nix_shell"
          "rust"
          "cmd_duration\n"
          "character"
        ];

        git_metrics.disabled = false;

        nix_shell = {
          symbol = "󱄅";
          impure_msg = "!";
          pure_msg = "";
          format = "[|](237) [$symbol](blue)[$state](cyan) $name ";
        };

        rust = {
          symbol = "󱘗";
          format = "[|](237) [$symbol](red) $version ";
          version_format = "$raw";
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

    # Custom syntax theme, looks like the tree-sitter syntax highlighting I already have
    # FIXME: Maybe tweak this a bit, I dunno.
    configFile."fish/themes/fht.theme".text = with import ../../theme; ''
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
  };
}
