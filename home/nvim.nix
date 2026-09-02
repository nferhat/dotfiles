{config, pkgs, ...}: {
  home.packages = [pkgs.neovim pkgs.gcc];
  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/nferhat/Documents/repos/personal/dotfiles/config/nvim";

  xdg.configFile."theme/colors.lua".text = let
    theme = import ../theme;
  in /* lua */ ''
    local Color = require("theme.color")
    return {
      color0 = Color:new({ hex  = "#${theme.ansi.color0}" }),
      color1 = Color:new({ hex  = "#${theme.ansi.color1}" }),
      color2 = Color:new({ hex  = "#${theme.ansi.color2}" }),
      color3 = Color:new({ hex  = "#${theme.ansi.color3}" }),
      color4 = Color:new({ hex  = "#${theme.ansi.color4}" }),
      color5 = Color:new({ hex  = "#${theme.ansi.color5}" }),
      color6 = Color:new({ hex  = "#${theme.ansi.color6}" }),
      color7 = Color:new({ hex  = "#${theme.ansi.color7}" }),
      color8 = Color:new({ hex  = "#${theme.ansi-bright.color8}" }),
      color9 = Color:new({ hex  = "#${theme.ansi-bright.color9}" }),
      color10 = Color:new({ hex = "#${theme.ansi-bright.color10}" }),
      color11 = Color:new({ hex = "#${theme.ansi-bright.color11}" }),
      color12 = Color:new({ hex = "#${theme.ansi-bright.color12}" }),
      color13 = Color:new({ hex = "#${theme.ansi-bright.color13}" }),
      color14 = Color:new({ hex = "#${theme.ansi-bright.color14}" }),
      color15 = Color:new({ hex = "#${theme.ansi-bright.color15}" }),
      bg = {
	primary = Color:new({ hex = "#${theme.background.primary}" }),
	secondary = Color:new({ hex = "#${theme.background.secondary}" }),
	tertiary = Color:new({ hex = "#${theme.background.tertiary}}" }),
      },
      text = {
	primary = Color:new({ hex = "#${theme.text.primary}" }),
	secondary = Color:new({ hex = "#${theme.text.secondary}" }),
	tertiary = Color:new({ hex = "#${theme.text.tertiary}}" }),
      },
      separator = Color:new({ hex = "#${theme.separator}" }),
    }
  '';
}
