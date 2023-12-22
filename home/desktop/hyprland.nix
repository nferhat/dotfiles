{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;

    # How use the home-manager module to define a hyprland configuration using nix.
    # Better than writing whatever vaxry wants your to write....
    settings = {
      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        layout = "master";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000065)";
      };

      animations = {
        enabled = true;
        animation = [
          "border, 1, 2, default"
          "fade, 1, 4, default"
          "windows, 1, 3, default, popin 80%"
          "workspaces, 1, 2.5, default, slide"
        ];
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        accel_profile = "flat";
      };

      master.new_is_master = false;

      gestures.workspace_swipe = true;

      misc = {
        vrr = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_splash_rendering = true;
        background_color = "rgb(101010)";
      };

      windowrulev2 = [
        "float,class:^(nvidia-settings|org.keepassxc.KeePassXC|nwg-look|Virt-manager|pineentry|virt-manager)$"
        "float,class:^(file_progress|confirm|dialog|download|notification|error|splash|confirmreset)$"
        "workspace 2,class:^(firefox)$"
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "workspace 3,class:^(discord|telegram)$"
        "workspace 6,class:^(Celeste.bin.x86_64|steam_app_*|osu!|Grapejuice|Etterna|Quaver)$"
        "float,class:^(Celeste.bin.x86_64|steam_app_*|osu!|Grapejuice|Etterna|Quaver)$"
        "center 1,class:^(osu!|Celeste.bin.x86_64|Etterna|Quaver)$"
        "size 1280 720,class:^(osu!|Celeste.bin.x86_64|Etterna|Quaver)$"
        "workspace 6,class:^(steam|org.prismlauncher.PrismLauncher)$"
        "float,class:^(steam|org.prismlauncher.PrismLauncher)$"
      ];

      layerrule = [
        "blur, eww"
        "blur, wofi"
        "ignorealpha, 0.5, eww"
        "ignorealpha, 0.5, wofi"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, mouse:272, movewindow"
      ];

      "$mod" = "SUPER";
      bind = let
        # Thank you github:fufexan/dotfiles for this.
        # Shorthand for generating workspace bindings.
        workspaceBinds = builtins.concatLists (builtins.genList (
            x: let
              c = (x + 1) / 10;
              key = builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${key}, workspace, ${builtins.toString (x + 1)}"
              "$mod SHIFT, ${key}, movetoworkspacesilent, ${builtins.toString (x + 1)}"
            ]
          )
          10);
        focusBinds = builtins.map (key: "$mod, ${lib.toUpper key}, movefocus, ${key}") ["h" "j" "k" "l"];
      in
        [
          # HACK: wezterm still doesn't launch under native wayland
          "$mod, Return, exec, env -u WAYLAND_DISPLAY wezterm"
          "$mod SHIFT, c, killactive"
          "$mod SHIFT, Q, exit"
          "$mod CTRL, Space, togglefloating"
          "$mod, P, exec, wofi"

          "$mod, F, fullscreen, 0"
          "$mod, M, fullscreen, 1"
        ]
        ++ workspaceBinds
        ++ focusBinds;
    };
  };
}
