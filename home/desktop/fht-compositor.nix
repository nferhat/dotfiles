{
  config,
  inputs,
  ...
}: {
  imports = [inputs.fht-compositor.homeModules.default];

  # Main compositor configuration is done through the home-manager module.
  # NOTE: Instead of autostart, we setup services in home/desktop/services.nix
  programs.fht-compositor = let
    theme = import ../../theme;
  in {
    enable = true;
    settings = {
      # Keep a temporary config file that I use sometimes to make on-the-fly changes
      imports = ["~/.config/fht/compositor-temp.toml"];

      general = {
        cursor-warps = true;
        focus-new-windows = true;
        focus-follows-mouse = false;
        layouts = ["tile" "bottom-stack" "centered-master" "floating"];
        nmaster = 1;
        mwfact = 0.5;
        inner-gaps = 8;
        outer-gaps = 20;
      };

      cursor = {inherit (config.home.pointerCursor) name size;};

      decorations = {
        decoration-mode = "force-server-side";

        border = {
          thickness = 3;
          radius = 25;
          focused-color = {
            start = theme.ansi.color2;
            end = theme.ansi.color4;
            angle = 0;
          };
          normal-color = "transparent";
          # normal-color = theme.ansi-bright.color8;
        };

        shadow = {
          sigma = 30;
          color = "#000";
          floating-only = false;
        };

        blur = {
          radius = 3;
          passes = 4;
          noise = 0.12;
        };
      };

      input.keyboard = {
        layout = "us";
        repeat-rate = 50;
        repeat-delay = 250;
      };

      animations = {
        window-geometry.curve = {
          clamp = true;
          damping-ratio = 1.2;
          mass = 2;
          initial-velocity = 1;
          stiffness = 1200;
          # NOTE: For window geometry its fine having epsilon this low since
          # they are interpolated in/out the start/end smoothly without blocking anything
          epsilon = 0.00000001;
        };

        window-open-close.curve = {
          clamp = true;
          damping-ratio = 1.2;
          initial-velocity = 1;
          mass = 1.5;
          stiffness = 900;
          # NOTE: For window open-close its fine having epsilon this low since
          # It doesnt block/affect anything else except the animation itself.
          epsilon = 0.000000001;
        };

        workspace-switch = {
          direction = "vertical";
          curve = {
            clamp = true;
            damping-ratio = 1;
            initial-velocity = 5;
            mass = 1;
            stiffness = 700;
          };
        };
      };

      keybinds = {
        # Example key actions that do not need any argument
        Super-q = "quit";
        Super-Ctrl-r = "reload-config";

        # Example key actions that need an argument passed in
        Super-Return = {
          action = "run-command";
          arg = "ghostty";
        };
        Super-p = {
          action = "run-command";
          arg = "wofi --show drun";
        };
        Super-Shift-s = {
          action = "run-command";
          # FIXME: Why using --copy does not work? Resorting to using stdout + wl-copy instead
          arg = "watershot --stdout | wl-copy";
        };

        # Focus management
        Super-j = "focus-next-window";
        Super-k = "focus-previous-window";
        Super-Shift-j = "swap-with-next-window";
        Super-Shift-k = "swap-with-previous-window";
        Super-Ctrl-j = "focus-next-output";
        Super-Ctrl-k = "focus-previous-output";
        # windows-style since sometimes muscle memory gets to me
        Alt-tab = {
          action = "focus-next-window";
          repeat = true;
        };
        Alt-Shift-tab = {
          action = "focus-previous-window";
          repeat = true;
        };

        # Window management
        Super-m = "maximize-focused-window";
        Super-f = "fullscreen-focused-window";
        Super-Shift-c = "close-focused-window";
        Super-Ctrl-Space = "float-focused-window";

        # Volume control
        XF86AudioRaiseVolume = {
          action = "run-command";
          arg = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+";
          allow-while-locked = true;
          repeat = true;
        };
        # ----
        XF86AudioLowerVolume = {
          action = "run-command";
          arg = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%-";
          allow-while-locked = true;
          repeat = true;
        };

        # Floating window management
        Super-Left = {
          action = "move-floating-window";
          arg = [(-50) 0];
          repeat = true;
        };
        Super-Right = {
          action = "move-floating-window";
          arg = [50 0];
          repeat = true;
        };
        Super-Up = {
          action = "move-floating-window";
          arg = [0 (-50)];
          repeat = true;
        };
        Super-Down = {
          action = "move-floating-window";
          arg = [0 50];
          repeat = true;
        };
        Super-Ctrl-c = "center-floating-window";

        Super-Shift-Left = {
          action = "resize-floating-window";
          arg = [(-50) 0];
          repeat = true;
        };
        Super-Shift-Right = {
          action = "resize-floating-window";
          arg = [50 0];
          repeat = true;
        };
        Super-Shift-Up = {
          action = "resize-floating-window";
          arg = [0 (-50)];
          repeat = true;
        };
        Super-Shift-Down = {
          action = "resize-floating-window";
          arg = [0 50];
          repeat = true;
        };

        # Transient layout changes.
        # Any changes set using these keybinds will be reset on configuration reload
        Super-Space = "select-next-layout";
        Super-Shift-Space = "select-previous-layout";
        Super-h = {
          action = "change-mwfact";
          arg = -0.05;
        };
        Super-l = {
          action = "change-mwfact";
          arg = 0.05;
        };
        Super-Shift-h = {
          action = "change-nmaster";
          arg = 1;
        };
        Super-Shift-l = {
          action = "change-nmaster";
          arg = -1;
        };
        Super-i = {
          action = "change-window-proportion";
          arg = 0.5;
        };
        Super-o = {
          action = "change-window-proportion";
          arg = -0.5;
        };

        # Workspaces
        # Super-Left = "focus-previous-workspace";
        # Super-Right = "focus-next-workspace";
        Super-1 = {
          action = "focus-workspace";
          arg = 0;
        };
        Super-2 = {
          action = "focus-workspace";
          arg = 1;
        };
        Super-3 = {
          action = "focus-workspace";
          arg = 2;
        };
        Super-4 = {
          action = "focus-workspace";
          arg = 3;
        };
        Super-5 = {
          action = "focus-workspace";
          arg = 4;
        };
        Super-6 = {
          action = "focus-workspace";
          arg = 5;
        };
        Super-7 = {
          action = "focus-workspace";
          arg = 6;
        };
        Super-8 = {
          action = "focus-workspace";
          arg = 7;
        };
        Super-9 = {
          action = "focus-workspace";
          arg = 8;
        };

        # Sending windows to workspaces
        Super-Shift-1 = {
          action = "send-to-workspace";
          arg = 0;
        };
        Super-Shift-2 = {
          action = "send-to-workspace";
          arg = 1;
        };
        Super-Shift-3 = {
          action = "send-to-workspace";
          arg = 2;
        };
        Super-Shift-4 = {
          action = "send-to-workspace";
          arg = 3;
        };
        Super-Shift-5 = {
          action = "send-to-workspace";
          arg = 4;
        };
        Super-Shift-6 = {
          action = "send-to-workspace";
          arg = 5;
        };
        Super-Shift-7 = {
          action = "send-to-workspace";
          arg = 6;
        };
        Super-Shift-8 = {
          action = "send-to-workspace";
          arg = 7;
        };
        Super-Shift-9 = {
          action = "send-to-workspace";
          arg = 8;
        };
      };

      mousebinds = {
        Super-Left = "swap-tile";
        Super-Right = "resize-tile";
      };

      rules = [
        # All windows on workspace 6 (reserved for games) must be floating
        {
          on-workspace = 5;
          match-title = [
            "^Minecraft.*" # minecraft sets blank app-id
            "GT: New Horizons.*" # modpack for minecraft
          ];
          match-app-id = [
            "Celeste.bin.x86_64"
            "steam_app_*"
            "osu!.exe"
            "Etterna"
            "Quaver"
            "Steam"
            "love" # love2d based games/apps, notably Olympus for celeste
            "org.prismlauncher.PrismLauncher"
          ];
          blur.disable = true; # to get slightly more performance
          floating = true;
          centered = true;
          open-on-workspace = 5;
          vrr = true;
        }

        # Web browsers open on workspace 2
        {
          match-app-id = ["LibreWolf" "zen-twilight"];
          open-on-workspace = 1;
        }

        # picture-in-picture mode
        {
          match-all = true;
          match-title = ["Picture-in-Picture"];
          match-app-id = ["zen-twilight"];
          floating = true;
          ontop = true;
          border.thickness = 0;
        }

        # Chat clients on workspace 3
        {
          match-app-id = ["vesktop" "Telegram" "org.gnome.Fractal"];
          match-title = [".*Telegram.*"];
          open-on-workspace = 2;
        }

        # Floating clients
        {
          match-title = [
            ".*KeePassXC.*"
            ".*QEMU.*"
            "Virtual Machine Manager"
            "Bluetooth Devicecs" # bluez device manager
          ];
          match-app-id = [
            # Most gnome apps behave better when floating.
            "^(org.gnome.*)$"
            "org.squidowl.halloy"
            "file_progress"
            "confirm"
            "dialog"
            "download"
            "pinentry"
            "splash"
            "gay.pancake.lsfg-vk-ui"
          ];
          floating = true;
          centered = true;
        }

        # gpu-screen-recorder hacking to get it to "work"
        # Eh, its not the best, I have it installed through flatpak, but it works I guess?
        {
          match-title = ["^(gsr ui)$" "^(gsr notify)$"];
          floating = true;
          fullscreen = false;
          blur.disable = true;
          border = {
            thickness = 0;
            radius = 0;
          };
          ontop = true;
        }
        # Place the notification at the edge of the screen, where its supposed to be.
        # ---
        # With skip-focus we won't be able to focus it. The real solution would have been to
        # actually use layer-shells for this, but I am too lazy to separate gsr-notify codebase
        # into two for that. (at least as of right now)
        {
          match-title = ["^(gsr notify)$"];
          skip-focus = true;
          location = {
            x = 2080;
            y = 150;
          };
        }
      ];

      layer-rules = [
        {
          # Blur wofi (app launcher) and make it slightly transparent
          match-namespace = ["wofi"];
          shadow = {
            disable = false;
            color = "black";
          };
          blur = {
            disable = false;
            noise = 0;
          };
          corner-radius = 25;
        }
      ];
    };
  };
}
