{
  config,
  lib,
  pkgs,
  ...
}: {
  # NOTE: Don't use `programs.neovim` since I manage my configuration myself.

  home = {
    packages = with pkgs; [
      # Base + runtime dependencies
      neovim-unwrapped
      ripgrep
      fd
      # NOTE: I've changed my mind on how I setup language servers, and instead install
      # and configure them inside a flake.nix devShell, which is more of the 'nix' way.
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  xdg.configFile = {
    "nvim" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/config/nvim";
    };

    "theme/colors.lua" = {
      enable = true;
      text = let
        toLuaColorStr = attrs:
          lib.concatStringsSep "\n" (
            lib.mapAttrsToList (n: v: "  ${n}='#${v}',") attrs
          );
      in ''
        return {
        ${toLuaColorStr config.theme.colors}
        ${toLuaColorStr config.theme.material.colors}
        }
      '';
    };
  };
}
