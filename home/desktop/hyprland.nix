{
  config,
  inputs,
  inputs',
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];

  home.packages = with pkgs; [
    # grim+slurp: Base utils
    # grimblast: wrapper around them to have a better life.
    grim
    slurp
    inputs'.hyprland-contrib.packages.grimblast

    inputs'.hyprpicker.packages.default # color picker
    gtklock # lock screen, very useful
  ];

  # Wallpaper daemon using wbg
  # Restarts whenever wbg gets killed
  systemd.user.services."wbg" = {
    Unit = {
      Description = "Wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.wbg}/bin/wbg ${config.theme.wallpaper}";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # How use the home-manager module to define a hyprland configuration using nix.
    # Better than writing whatever vaxry wants your to write....
    settings = {
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        layout = "master";
        "col.active_border" = "rgb(${config.theme.material.colors.primary})";
        "col.inactive_border" = "rgb(${config.theme.material.colors.outline_variant})";
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
        "col.shadow" = "rgba(0000007f)";
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

      master = {
        new_is_master = false;
        mfact = 0.5; # WHY ISNT THIS THE DEFAULT
      };

      gestures.workspace_swipe = true;

      misc = {
        vrr = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;

        # Just useless soo ehh
        disable_splash_rendering = true;
        disable_hyprland_logo = true;

        # More animations
        animate_mouse_windowdragging = true;
        animate_manual_resizes = true;

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

      # Disable stupid laptop keyboard that is buggy
      "device:at-translated-set-2-keyboard".enabled = false;

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, mouse:272, movewindow"
      ];

      "$mod" = "SUPER";
      bind = let
        toBindStr = {
          modifiers ? [],
          key,
          dispatch,
          args ? "",
        }: let
          modifiersStr = lib.concatStringsSep " " modifiers;
          ret = lib.concatStringsSep "," [modifiersStr key dispatch (builtins.toString args)];
        in
          ret;

        # Thank you github:fufexan/dotfiles for this.
        # Shorthand for generating workspace bindings.
        workspaceBinds = builtins.concatLists (builtins.genList (
            x: let
              c = (x + 1) / 10;
              key = builtins.toString (x + 1 - (c * 10));
            in [
              {
                inherit key;
                modifiers = ["SUPER"];
                dispatch = "workspace";
                args = x + 1;
              }
              {
                inherit key;
                modifiers = ["SUPER" "SHIFT"];
                dispatch = "movetoworkspacesilent";
                args = x + 1;
              }
            ]
          )
          10);

        # Disable animations to get rid of black border around screenshot
        screenshot-area = ''
          hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copy area; hyprctl keyword animation 'fadeOut,1,4,default'
        '';
      in
        builtins.map toBindStr (
          [
            {
              modifiers = ["SUPER" "SHIFT"];
              key = "c";
              dispatch = "killactive";
            }
            {
              modifiers = ["SUPER" "SHIFT"];
              key = "q";
              dispatch = "exit";
            }

            # General applications/prgorams
            {
              # HACK: wezterm still doesn't launch under native wayland
              modifiers = ["SUPER"];
              key = "Return";
              dispatch = "exec";
              args = "env -u WAYLAND_DISPLAY wezterm";
            }
            {
              modifiers = ["SUPER"];
              key = "p";
              dispatch = "exec";
              args = "wofi";
            }
            {
              modifiers = ["SUPER"];
              key = "l";
              dispatch = "exec";
              args = "gtklock";
            }
            {
              modifiers = ["SUPER"];
              key = "c";
              dispatch = "exec";
              args = "hyprpicker -n -a -f rgb";
            }

            # Layout gimmicks
            {
              modifiers = ["SUPER" "CTRL"];
              key = "Space";
              dispatch = "togglefloating";
            }
            {
              modifiers = ["SUPER"];
              key = "f";
              dispatch = "fullscreen";
              args = 1;
            }
            {
              modifiers = ["SUPER"];
              key = "m";
              dispatch = "fullscreen";
              args = 0;
            }

            # See comment above for more info
            # Screenshotting funsies, similar to windows
            {
              modifiers = ["SUPER" "SHIFT"];
              key = "s";
              dispatch = "exec";
              args = screenshot-area;
            }
            {
              key = "Print";
              dispatch = "exec";
              args = "grimblast --notify copy output";
            }

            # Apparently using builtins.map doesnt work soo.
            {
              modifiers = ["SUPER"];
              key = "j";
              dispatch = "cyclenext";
            }
            {
              modifiers = ["SUPER"];
              key = "k";
              dispatch = "cyclenext";
              args = "prev";
            }
            {
              modifiers = ["SUPER" "SHIFT"];
              key = "j";
              dispatch = "swapnext";
            }
            {
              modifiers = ["SUPER" "SHIFT"];
              key = "j";
              dispatch = "swapnext";
              args = "prev";
            }

            # Volume control
            {
              key = "XF86AudioRaiseVolume";
              dispatch = "exec";
              args = "wpctl set-volume -l \"1.0\" @DEFAULT_AUDIO_SINK@ 5%+";
            }
            {
              key = "XF86AudioLowerVolume";
              dispatch = "exec";
              args = "wpctl set-volume -l \"1.0\" @DEFAULT_AUDIO_SINK@ 5%-";
            }
            {
              key = "XF86AudioMute";
              dispatch = "exec";
              args = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            }
          ]
          ++ workspaceBinds
        );
    };
  };
}
