{
self,
pkgs,
inputs,
...
}:

# qt.nix -*- Theming QT applications.
# kosslan's QtEngine helps massively, and I can load KDE plasma themes fine.

{
  imports = [inputs.qtengine.nixosModules.default];

  # Configure QT on the system and for my user.
  # Allows to find themes from QtEngine
  qt = { enable = true; platformTheme = null; };
  nferhat.qt = { enable = true; platformTheme.name = null; };

  # Set the theme. Finally done with qt*ct
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qtengine";
  environment.systemPackages = with pkgs; [
    # For now I shall use breeze for a while. Works decent enough (better than having all my QT
    # apps blinding me, woo)
    kdePackages.breeze
    kdePackages.breeze.qt5
    kdePackages.dolphin
    # Custom theme
    self.packages."${pkgs.system}".arashi-icon-theme
  ];

  # FIXME: Make my custom theme for QT apps.
  # I dont know the theme tokens and whatnot zzzzzz
  programs.qtengine = {
    enable = true;
    config = {
      theme = {
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
}
