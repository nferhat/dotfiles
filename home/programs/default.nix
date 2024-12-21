{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./helix.nix
    ./git.nix
    ./tmux.nix
    ./zsh.nix
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
      l = "eza -ah --group-directories-first";
      ll = "l -l";
      htop = "btop"; # force of habit
    };
  };

  programs = {
    home-manager.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f"; # BLAZINGLY FAST!!!
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.configHome}/gnupg";
      mutableKeys = true; # just allow me to use it without nix entering
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    yt-dlp = {
      enable = true;
      settings = {
        embed-thumbnail = true;
        embed-subs = true;
      };
    };
  };
}
