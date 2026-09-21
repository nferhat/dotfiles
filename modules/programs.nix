{
  config,
  pkgs,
  ...
}: {
  nferhat.shellAliases = {
    l = "eza -a --group-directories-first";
    ll = "l -l";
    htop = "btop"; # force of habit
  };

  nferhat.programs = {
    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f"; # BLAZINGLY FAST!!!
    };

    gpg = {
      enable = true;
      homedir = "${config.nferhat.xdg.configHome}/gnupg";
      mutableKeys = true; # just allow me to use it without nix entering
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    nh = {
      enable = true;
      # TODO: Maybe automate getting this value? Though I don't move the dotfiles
      flake = "/home/nferhat/Documents/repos/personal/dotfiles";
      clean = {
        enable = true;
        extraArgs = "--keep-since 1w";
      };
    };

    yt-dlp = {
      enable = true;
      settings = {
        embed-thumbnail = true;
        embed-subs = true;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # Additional stuff that only really makes sense for me only.
  # No need for all the system to have this.
  nferhat.packages = with pkgs; [
    dnsutils
    aria2
    socat
    netcat
    nmap
    jq
    ripgrep
    eza
    tree
    nix-output-monitor
    glow
    tokei
    btop
    pciutils
    usbutils
    findutils
    ffmpeg
    libqalculate
    dust
    trash-cli
  ];

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
