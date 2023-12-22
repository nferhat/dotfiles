{
  pkgs,
  lib,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      # regular UI fonts
      noto-fonts
      twemoji-color-font
      google-fonts

      # monospace
      iosevka
      (nerdfonts.override {fonts = ["Iosevka"];})
    ];

    # NOTE: I do not want serif fonts, deal with it.
    fontconfig.defaultFonts = {
      serif = ["Inter" "Twemoji" "Iosevka" "Iosevka Nerd Font"];
      sansSerif = ["Inter" "Twemoji" "Iosevka" "Iosevka Nerd Font"];
      monospace = ["Iosevka" "Iosevka Nerd Font"];
      emoji = ["Twemoji"];
    };

    # Apparently this causes more issues with font dependencies.
    # TODO: Investigate
    enableDefaultPackages = lib.mkForce false;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    # XDG variables setup
    # safe defaults, in case the xdg nixos module, setting them here to avoid race conditions
    # as the xdg module sets them after `environment.variables` are set.
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  programs = {
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  services = {
    dbus.packages = [pkgs.dconf];

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
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
