{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fzf
    findutils # for xargs
  ];

  programs.git = {
    enable = true;
    userName = "nferhat";
    userEmail = "nferhat20@gmail.com";

    aliases = {
      # Blantantly copied from my old config, it just works!
      add-select = "!git status --short | fzf | awk '{print $2}' | xargs -r git add";
      br = "branch";
      ba = "branch --all";
      bd = "branch -D";
      ca = "commit --all";
      ci = "commit";
      cl = "clone";
      co = "checkout";
      cp = "cherry-pick";
      st = "status";
      hist = "log --all - graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'";
      llog = "log --graph --name-status --pretty=format:'%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset' --date=relative";
      ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
      pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
      af = "!git add $(git ls-files -m -o --exclude-standard | fzf -m)";
    };

    extraConfig = {
      init.defaultBranch = "main"; # force of habit, I guess (and github forcing it)
      user.signingkey = lib.mkDefault "79E6CEB6B608B845";
      commit.gpgsign = true;
      core = {
        ignoreCase = true;
        symlinks = true;
        editor = config.home.sessionVariables.EDITOR;
      };
    };

    delta.enable = true; # very useful
  };

  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-notify];
  };

  home.shellAliases = {
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
