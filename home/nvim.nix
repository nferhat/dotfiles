{pkgs, ...}: {
  home.packages = [pkgs.neovim pkgs.gcc];
  home.sessionVariables.EDITOR = "nvim";
}
