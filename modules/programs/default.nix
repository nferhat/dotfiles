{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./networking.nix
    ./nvim.nix
    ./podman.nix
    ./tmux.nix
  ];

  nferhat.shellAliases = {
    l = "eza -a --group-directories-first";
    ll = "l -l";
    htop = "btop"; # force of habit
  };

  # Additional stuff that only really makes sense for me only.
  # No need for all the system to have this.
  nferhat.packages = with pkgs; [
    jq
    ripgrep
    eza
    tokei
    btop
    ffmpeg
    dust
    trash-cli
  ];

  nferhat.programs = {
    # fzf is at the core of my workflow.
    # I use it to enter my editor, search for projects, Ctrl-R reverse search in my history...
    # Every part is mapped to it. And, with `fd`, its blazingly fast.
    fzf = {
      enable = true;
      defaultCommand = "fd --type f";
    };

    # zoxide, just like fzf, is essential for my workflow.
    # Allows me to jump to projects really fast, but is also a good general tool for going around.
    zoxide.enable = true;

    # direnv is also essential. Mostly to enter devShells on cd.
    # otherwise I don't care about all its other features.
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # gpg for signing.
    # FIXME: Manage my secrets with agenix and put them with Nix. Whatever whatever.
    # I really don't know about this, and the implications that it causes.
    gpg = {
      enable = true;
      homedir = "${config.nferhat.xdg.configHome}/gnupg";
      mutableKeys = true; # just allow me to use it without nix entering
    };

    # nh streamlines managing the dotfiles.
    # Auto-integrates nix-output-monitor and whatnot, zzz
    nh = {
      enable = true;
      # TODO: Maybe automate getting this value? Though I don't move the dotfiles
      flake = "/home/nferhat/Documents/repos/personal/dotfiles";
      clean = {
        enable = true;
        extraArgs = "--keep-since 1w";
      };
    };

    # Useful, without having to say anything.
    yt-dlp = {
      enable = true;
      settings = {
        embed-thumbnail = true;
        embed-subs = true;
      };
    };
  };

  nferhat.services = {
    ssh-agent.enable = true;

    gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      defaultCacheTtl = 600; # validate for 10 minutes.
      pinentry.package = pkgs.pinentry-qt;
    };

    gnome-keyring.enable = true;
  };
}
