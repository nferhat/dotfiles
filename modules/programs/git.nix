{
  lib,
  config,
  pkgs,
  ...
}: {
  nferhat.packages = with pkgs; [fzf findutils gh];

  nferhat.programs.git = {
    enable = true;

    settings = {
      user = {
        name = "nferhat";
        email = "nadjib.ferhat@etu.usthb.dz";
      };

      core = {
        ignoreCase = true;
        symlinks = true;
        editor = config.environment.sessionVariables.EDITOR;
      };

      init.defaultBranch = "main"; # force of habit, I guess (and github forcing it)
      user.signingkey = lib.mkDefault "79E6CEB6B608B845";
      commit.gpgsign = true;
    };
  };

  # Better diff tool, very useful and somewhat underrated.
  nferhat.programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  nferhat.shellAliases = {
    gc = "git commit";
    gco = "git checkout";
    ga = "git add";
    gap = "git add --patch";
    gb = "git branch";
    gd = "git diff -w";
    gds = "git diff -w --staged";
    gst = "git status || l";
    gS = "git stash";
    gl = "git llog";
  };
}
