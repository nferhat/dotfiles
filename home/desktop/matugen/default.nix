{config, inputs, pkgs, lib, ...}: {
  imports = [inputs.matugen.nixosModules.default];

  # Enable matugen, since I have some custom templates to work my with neovim config (to change
  # background shades), and I have DMS configured to automatically generate the templates from it.
  programs.matugen = let
    inherit (config.xdg) configHome;
  in {
    enable = true;
    wallpaper.set = false; # DMS already handles that
    templates = {
      "fht-compositor" = {
        input_path = ./fht-compositor.toml;
        output_path = "${configHome}/fht/dank-colors.toml";
      };
      "ghostty-without-ansi" = {
        input_path = ./ghostty;
        output_path = "${configHome}/ghostty/config-colors";
      };
      "neovim-background-shades" = {
        input_path = ./neovim.lua;
        output_path = "${configHome}/nvim/matugen-colors.lua";
      };
    };
  };

  # Generate the matugen config file for dms to pick up
  xdg.configFile."matugen/config.toml".source = let
    tomlFormat = pkgs.formats.toml {};
  in tomlFormat.generate "matugen-config" {
    config = {};
    templates = config.programs.matugen.templates;
  };
}
