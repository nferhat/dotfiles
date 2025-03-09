{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./helix.nix
    ./git.nix
    ./tmux.nix
    ./fish.nix
  ];

  home = {
    packages = with pkgs; [
      # The essentials for working in the terminal, but not forcibly required for
      # all the system, hence why some programs are here and not inside the `core.nix`
      # nixos module
      dnsutils
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
    ];

    shellAliases = {
      l = "eza -a --group-directories-first";
      ll = "l -l";
      htop = "btop"; # force of habit
    };
  };

  programs = {
    home-manager.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f"; # BLAZINGLY FAST!!!
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.configHome}/gnupg";
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
}
