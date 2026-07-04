{lib, ...}: {
  boot.loader.limine = {
    enable = true;
    secureBoot = { enable = true; autoGenerateKeys = false; };
    efiSupport = true;
    maxGenerations = 16;

    style = let
      theme = import ../../theme;
      paletteColors = with theme.ansi; [color0 color1 color2 color3 color4 color5 color6 color7];
      brightPaletteColors = with theme.ansi-bright; [color8 color9 color10 color11 color12 color13 color14 color15];
      mkPallete = p: lib.concatStringsSep ";" p;
    in {
      backdrop = theme.background.primary;
      graphicalTerminal = {
        background = "9F${theme.background.tertiary}";
        foreground = theme.text.primary;
        margin = 30;
        brightBackground = theme.background.secondary;
        brightForeground = "FFFFFF";
        palette = mkPallete paletteColors;
        brightPalette = mkPallete brightPaletteColors;
      };
    };
  };
}
