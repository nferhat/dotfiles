{
  self,
  lib,
  pkgs,
  ...
}: {
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

  # Allow packages installed with hm to find system fonts and stuff installed
  # with `nferhat.packages`
  nferhat.fonts.fontconfig = {
    enable = true;
    # Additional tweaking to make font rendering look nice.
    subpixelRendering = "rgb";
    antialiasing = true;
  };
}
