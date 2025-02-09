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
      general = {
        cursor-warps = true;
        focus-new-windows = true;
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
            start = theme.ansi.color4;
            end = theme.ansi.color6;
            angle = 0;
          };
          normal-color = "transparent";
          # normal-color = theme.ansi-bright.color8;
        };

        shadow = {
          sigma = 10;
          color = "#000";
          floating-only = false;
        };

        blur = {
          radius = 1;
          passes = 4;
          noise = 0.1;
        };
      };

      input = {
        keyboard = {
          layout = "us";
          repeat-rate = 50;
          repeat-delay = 250;
        };

        per-device = {
          "SynPS/2 Synaptics TouchPad".mouse.tap-to-click = true;
        };
      };

      # I like the defaults that are on Niri, so I use that :p
      # Its probably also copied from GTK4/Libadwaita
      animations = let
        smooth-spring = stiffness: {
          inherit stiffness;
          initial-velocity = 1;
          damping-ratio = 1;
          mass = 1;
          clamp = true;
        };
      in {
        window-geometry.curve = smooth-spring 800;
        window-open-close.curve = smooth-spring 700 // {damping-ratio = 1.1;};
        workspace-switch = {
          direction = "vertical";
          curve = smooth-spring 1000;
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
          arg = ''grim -g "`slurp -o`" - | wl-copy --type image/png'';
        };

        # Focus management
        Super-j = "focus-next-window";
        Alt-tab = "focus-next-window";
        Super-k = "focus-previous-window";
        Alt-Shift-tab = "focus-previous-window";
        Super-Shift-j = "swap-with-next-window";
        Super-Shift-k = "swap-with-previous-window";
        Super-Ctrl-j = "focus-next-output";
        Super-Ctrl-k = "focus-previous-output";

        # Window management
        Super-m = "maximize-focused-window";
        Super-f = "fullscreen-focused-window";
        Super-Shift-c = "close-focused-window";
        Super-Ctrl-Space = "float-focused-window";

        # Floating window management
        Super-Left = {
          action = "move-floating-window";
          arg = [(-50) 0];
        };
        Super-Right = {
          action = "move-floating-window";
          arg = [50 0];
        };
        Super-Up = {
          action = "move-floating-window";
          arg = [0 (-50)];
        };
        Super-Down = {
          action = "move-floating-window";
          arg = [0 50];
        };
        Super-Ctrl-c = "center-floating-window";

        Super-Shift-Left = {
          action = "resize-floating-window";
          arg = [(-50) 0];
        };
        Super-Shift-Right = {
          action = "resize-floating-window";
          arg = [50 0];
        };
        Super-Shift-Up = {
          action = "resize-floating-window";
          arg = [0 (-50)];
        };
        Super-Shift-Down = {
          action = "resize-floating-window";
          arg = [0 50];
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
          arg = 0.1;
        };
        Super-o = {
          action = "change-window-proportion";
          arg = -0.1;
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
          floating = true;
          centered = true;
        }

        # Web browsers open on workspace 2
        {
          match-app-id = ["LibreWolf"];
          open-on-workspace = 1;
        }

        # Chat clients on workspace 3
        {
          match-app-id = ["WebCord" "Telegram" "org.gnome.Fractal"];
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
            "file_progress"
            "confirm"
            "dialog"
            "download"
            "pinentry"
            "splash"
          ];
          floating = true;
          centered = true;
        }
      ];
    };
  };
}
