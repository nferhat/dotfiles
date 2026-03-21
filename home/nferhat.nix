{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: {
  imports = let
    hasHostConfig = builtins.pathExists ./${osConfig.networking.hostName};
    hostConfig = lib.optional hasHostConfig ./${osConfig.networking.hostName};
  in
    [
      ./desktop
      ./services.nix
      # Program configuration. This is the core of my setup.
      ./neovim.nix
      ./tmux.nix
      ./fish.nix
      ./git.nix
    ]
    ++ hostConfig;

  home = {
    stateVersion = "23.11";
    username = "nferhat";
    homeDirectory = "/home/nferhat";

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
      ffmpeg
      libqalculate
    ];

    shellAliases = {
      l = "eza -a --group-directories-first";
      ll = "l -l";
      htop = "btop"; # force of habit
    };

    sessionVariables = {
      # Cleanup of the home directory, thank you both:
      # * The arch linux wiki for XDG directory alternatives
      # * Luke Smith of the idea of cleaning up my ~/
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv/cuda";
      GOCACHE = "$XDG_CACHE_HOME/go/build";
      GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
      GOPATH = "$XDG_DATA_HOME/go";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      STARSHIP_CACHE = "$XDG_CACHE_HOME/starship";
      # STARSHIP_CONFIG = "$XDG_CONFIG_HOME/starship.toml";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
      __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    };
  };

  programs = {
    # home-manager.enable = true;
    command-not-found.enable = true;

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

  xdg.enable = true;
}
