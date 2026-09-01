{
  config,
  inputs,
  pkgs,
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
      env.DISPLAY = ":0"; # until I write the integration.

      general = {
        cursor-warps = true;
        focus-new-windows = true;
        focus-follows-mouse = false;
        layouts = ["binary-tree" "spiral-tree" "floating"];
        nmaster = 1;
        mwfact = 0.5;
        inner-gaps = 10;
        outer-gaps = 40;
      };

      cursor = {inherit (config.home.pointerCursor) name size;};

      decorations = {
        decoration-mode = "force-server-side";

        border = {
          thickness = 1;
          radius = 24;
          # power = 0;
          focused-color = theme.separator;
          normal-color = "transparent";
        };

        shadow = {
          sigma = 12.5;
          color = "#000";
          floating-only = false;
        };

        blur = {
          disable = true; # Not doing the blur thing anymore for now...
          radius = 4;
          passes = 4;
          noise = 0.045;
        };
      };

      input.keyboard = {
        layout = "us";
        repeat-rate = 50;
        repeat-delay = 250;
      };

      animations = {
        # window-open-close = {
        #   # Emphasized decelerate from material UI.
        #   # duration = md.sys.motion.duration.medium3
        #   duration = 400;
        #   curve = cubic-curve 0.05 0.7 0.1 1;
        # };

        # window-geometry = {
        #   # Standard curve from material UI
        #   # duration = md.sys.motion.duration.long2
        #   duration = 500;
        #   curve = cubic-curve 0.2 0 0 1.0;
        # };

        # workspace-switch = {
        #   direction = "horizontal";
        #   # Standard decelerate from material UI.
        #   # duration = md.sys.motion.duration.long4
        #   duration = 650;
        #   curve = cubic-curve 0 0 0 1;
        # };
      };

      keybinds = let
        # Some stuff to generalize writing actions.
        run = args-list: {
          action = "run";
          arg = args-list;
        };
        run-cmdline = cmdline: {
          action = "run-command-line";
          arg = cmdline;
        };

        # Execute an DankMaterialShell IPC action.
        # It's just a run command wrapped with `dms ipc`
        qs-ipc = args: run (["qs" "ipc" "call"] ++ args);

        # A global shortcut
        global-shortcut = arg: {
          action = "global-shortcut";
          inherit arg;
        };

        # Make an action repeating by passing it into this function.
        repeat = action:
          if builtins.typeOf action == "string"
          then {
            inherit action;
            repeat = true;
          }
          else action // {repeat = true;};

        # Make an action run even if the screen's locked by passing it into this function.
        allow-while-locked = action:
          if builtins.typeOf action == "string"
          then {
            inherit action;
            allow-while-locked = true;
          }
          else action // {allow-while-locked = true;};

        # Generate the workspace commands since they are always bound 1-9.
        workspaceKeybinds = let
          idxs = builtins.genList (i: i) 9;
          bindsList =
            map (i: {
              "Super-${toString (i + 1)}" = {
                action = "focus-workspace";
                arg = i;
              };
              "Super-Shift-${toString (i + 1)}" = {
                action = "send-to-workspace";
                arg = i;
              };
            })
            idxs;
        in
          builtins.foldl' (a: b: a // b) {} bindsList;
      in
        workspaceKeybinds
        // {
          # You need to have these otherwise you aint gonna do shit.
          Super-q = "none";
          Super-Ctrl-r = "reload-config";

          Super-Return = run ["ghostty"];
          Super-Shift-s = run-cmdline ''
            grim -g "$(slurp)" - | wl-copy --type image/png
          '';

          # Directional focus management
          # tree-like layouts from BSPWM are really nice.
          Super-Left = "focus-window-left";
          Super-Down = "focus-window-down";
          Super-Up = "focus-window-up";
          Super-Right = "focus-window-right";
          Super-Shift-Left = "swap-window-left";
          Super-Shift-Down = "swap-window-down";
          Super-Shift-Up = "swap-window-up";
          Super-Shift-Right = "swap-window-right";

          Super-Ctrl-j = "focus-next-output";
          Super-Ctrl-k = "focus-previous-output";
          # windows-style since sometimes muscle memory gets to me
          Alt-tab = repeat "focus-next-window";
          Alt-Shift-tab = repeat "focus-previous-window";

          # Window management
          Super-m = "maximize-focused-window";
          Super-f = "fullscreen-focused-window";
          Super-Shift-c = "close-focused-window";

          # Floating windows
          Super-Ctrl-Space = "float-focused-window";
          Super-Ctrl-c = "center-floating-window";

          # Different quickshell (wip) rice stuff.
          Super-c = global-shortcut "quickshell:toggleCentralPanel";
          Super-v = global-shortcut "quickshell:openClipboard";
          Super-p = global-shortcut "quickshell:openLauncher";

          # Volume control
          XF86AudioRaiseVolume = allow-while-locked (repeat (run ["wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "10%+"]));
          XF86AudioLowerVolume = allow-while-locked (repeat (run ["wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "10%-"]));

          # Locking
          Super-Alt-l = qs-ipc ["lock" "lock"];

          # Transient layout changes.
          # Any changes set using these keybinds will be reset on configuration reload
          Super-Space = "select-next-layout";
          Super-Shift-Space = "select-previous-layout";
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
            "steam"
            "Celeste.bin.x86_64"
            "steam_app_*"
            "osu!.exe"
            "Etterna"
            "Quaver"
            "Steam"
            "Ryujinx"
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
            "openrgb"
          ];
          floating = true;
          centered = true;
        }

        {
          match-app-id = [".*ghostty.*"];
          floating = false;
        }
      ];

      layer-rules = [
        # Working on a quickshell-based shell,
        # The bar looks nicer with shadows behind it, like my AWM rice used to have.
        {
          match-namespace = ["fht.desktop.Shell.*"];
          shadow.disable = false;
        }
      ];
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin
      "fht-share-picker"
      ''
        #!/usr/bin/env bash

        # fht-share-picker -*- Custom share picker based on quickshell.
        #
        # Based on: https://github.com/PZeide/shiny-shell/blob/main/scripts/shiny-hyprland-share-picker.sh
        # Thank you very much, nice stuff!!!!!!!!!!!!!!!!!!!

        RESPONSE=$(qs ipc --any-display call share-picker request {} 2>/dev/null) || {
        	echo "failed to request share-picker to open" >&2
                # FIXME: Fallback to default fht-share-picker.
        	exit 1
        }

        STATUS=$(echo "$RESPONSE" | jq -r '.status // empty')
        REQUEST_ID=$(echo "$RESPONSE" | jq -r '.data // empty')
        if [[ "$STATUS" != "ok" ]]; then
          echo "error" >&2
          exit 1
        fi

        while IFS= read -r line || break; do
          [[ -z "$line" ]] && exit 0

          KEY=$(echo "$line" | jq -r '.key // empty' 2>/dev/null)
          [[ "$KEY" != "$REQUEST_ID" ]] && continue

          # NOTE: Echoing nothing is considered to be cancelled in the portal code.
          # You should also output to stdout not stderr.
          RESULT_STATUS=$(echo "$line" | jq -r '.status // empty')
          [[ "$RESULT_STATUS" == "cancelled" ]] && exit 1

          echo "$line" | jq --raw-output --monochrome-output --compact-output '.result // empty'
          exit 0
        done < <(qs ipc --any-display listen share-picker result 2>/dev/null)
      '')
  ];
}
