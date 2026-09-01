{
  self,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.fht-compositor.nixosModules.default
    inputs.qtengine.nixosModules.default
  ];

  fonts = {
    packages = with pkgs; [
      # regular UI fonts
      adwaita-fonts
      twemoji-color-font
      # Monospace.
      self.packages.${pkgs.system}.fht-mono
      nerd-fonts.iosevka
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    # NOTE: I do not want serif fonts, deal with it.
    fontconfig.defaultFonts = {
      serif = ["Adwaita Sans" "Twemoji" "Fht Mono" "Iosevka Nerd Font"];
      sansSerif = ["Adwaita Sans" "Twemoji" "Fht Mono" "Iosevka Nerd Font"];
      monospace = ["Fht Mono" "Iosevka Nerd Font"];
      emoji = ["Twemoji"];
    };
    fontconfig.subpixel.rgba = "rgb";

    # Apparently this causes more issues with font dependencies.
    # TODO: Investigate
    enableDefaultPackages = lib.mkForce false;
  };

  environment.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "zeditor";
    # XDG variables setup
    # safe defaults, in case the xdg nixos module, setting them here to avoid race conditions
    # as the xdg module sets them after `environment.variables` are set.
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # Cripster font rendering.
    # FREETYPE_PROPERTIES = lib.concatStringsSep " " (let
    #   darkeningParams = [
    #     # Pairs of (<=stem-width in micropx, darkening-amount)
    #     500
    #     0 # <=0.5px -> 0px darkening...
    #     1000
    #     300
    #     2500
    #     500
    #     4000
    #     0
    #   ];
    #   darkeningParamsStr = lib.concatStringsSep "," (map toString darkeningParams);
    # in [
    #   # Enable darkening for CFF engine
    #   "cff:no-stem-darkening=0"
    #   "cff:darkening-parameters=${darkeningParamsStr}"
    #   # Enable darkening for Autohinting engine engine
    #   "autofitter:no-stem-darkening=0"
    #   "autofitter:darkening-parameters=${darkeningParamsStr}"
    #   # For type1 font rendering, even though it's not really used but still.
    #   "type1:no-stem-darkening=0"
    #   "t1cid:no-stem-darkening=0"
    # ]);

    # qtengine for theming qt stuff
    QT_QPA_PLATFORMTHEME = "qtengine";
  };

  # No thank you, this will just consume time trying to connect any present card instead of actually
  # letting the system boot
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.user.services.fht-compositor-polkit.enable = false;

  environment.systemPackages = with pkgs; [
    kdePackages.breeze
    kdePackages.breeze.qt5
    self.packages."${pkgs.system}".arashi-icon-theme
  ];

  programs = {
    dconf.enable = true;
    kdeconnect.enable = true;

    fht-compositor = {
      enable = true;
    };

    qtengine = {
      enable = true;

      config = {
        theme = {
          # FIXME: Custom theme
          colorScheme = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
          iconTheme = "Arashi";
          style = "breeze";

          font = {
            family = "Adwaita Sans";
            size = 12;
            weight = -1;
          };

          fontFixed = {
            family = "Fht Mono";
            size = 12;
            weight = -1;
          };
        };
        misc = {
          singleClickActivate = false;
          menusHaveIcons = true;
          shortcutsForContextMenus = true;
        };
      };
    };
  };

  qt = {
    enable = true;
    # Set it myself
    platformTheme = null;
  };

  services = {
    dbus.packages = [
      pkgs.dconf
      # This is required for pinentry-gnome3 to work since I am not
      # on a GNOME desktop environment.
      pkgs.gcr
    ];

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = lib.mkDefault false;
      };
      jack.enable = true;
      pulse.enable = true;
    };

    displayManager.ly = {
      enable = true;
      x11Support = false;
    };
  };

  # Depedency of pipewire.
  security.rtkit.enable = true;

  # Niceness and integration for wayland sessions
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = ["gtk"];
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
