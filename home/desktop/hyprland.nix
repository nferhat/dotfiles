{
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

  # TODO: Add wallpaper systemd service when I do theme module.

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
        # TODO: Add border color
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

        # Disable animations to get rid of black border around screenshot
        screenshot-area = ''
          hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copy area; hyprctl keyword animation 'fadeOut,1,4,default'
        '';
        screenshot-output = ''
          hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copy output; hyprctl keyword animation 'fadeOut,1,4,default'
        '';
      in
        [
          "$mod SHIFT, c, killactive"
          "$mod SHIFT, Q, exit"
          # General applications/prgorams
          # HACK: wezterm still doesn't launch under native wayland
          "$mod, Return, exec, env -u WAYLAND_DISPLAY wezterm"
          "$mod, P,      exec, wofi -I --show drun"
          "$mod, L,      exec, gtklock"
          "$mod, C,      exec, hyprpicker -n -a -f rgb"

          # Layout gimmicks
          "$mod CTRL, Space, togglefloating"
          "$mod, F, fullscreen, 0" # actual fullscreen
          "$mod, M, fullscreen, 1" # monocle

          # See comment above for more info
          "$mod SHIFT, S, exec, ${screenshot-area}"
          ", Print, exec, ${screenshot-output}"
          # Apparently using builtins.map doesnt work soo.
          "$mod, J, cyclenext,"
          "$mod, K, cyclenext, prev"
          "$mod SHIFT, J, swapnext,"
          "$mod SHIFT, K, swapnext,prev"
          # Volume control
          ",XF86AudioRaiseVolume,       exec, wpctl set-volume -l \"1.0\" @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume,       exec, wpctl set-volume -l \"1.0\" @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute,              exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ]
        ++ workspaceBinds;
    };
  };
}
