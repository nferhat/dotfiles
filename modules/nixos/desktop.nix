{
  self,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.fht-compositor.nixosModules.default];

  fonts = {
    packages = with pkgs; [
      # regular UI fonts
      adwaita-fonts
      twemoji-color-font
      google-fonts
      # Monospace. Fht Mono/Term are based on Iosevka
      self.packages."${pkgs.system}".fht-mono
      self.packages."${pkgs.system}".fht-term
      nerd-fonts.iosevka
    ];

    # NOTE: I do not want serif fonts, deal with it.
    fontconfig.defaultFonts = {
      serif = ["Adwaita Sans" "Twemoji" "Fht Mono" "Iosevka Nerd Font"];
      sansSerif = ["Adwaita Sans" "Twemoji" "Fht Mono" "Iosevka Nerd Font"];
      monospace = ["Fht Mono" "Iosevka Nerd Font"];
      emoji = ["Twemoji"];
    };

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
  };

  environment.systemPackages = [pkgs.gtklock];

  # For gtklock to work properly, pam needs to know about it.
  # This is why we must it up ourselves
  #
  # SEE: #383430 on nixpkgs for the module to come out
  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

  programs = {
    dconf.enable = true;
    kdeconnect.enable = true;

    fht-compositor = {
      enable = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
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
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
    };

    xserver.displayManager.gdm.enable = true;
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
