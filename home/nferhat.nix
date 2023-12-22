{
  osConfig,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./services.nix
  ];

  home = {
    inherit (osConfig.system) stateVersion;
    username = "nferhat";
    homeDirectory = "/home/nferhat";

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
      STARSHIP_CONFIG = "$XDG_CONFIG_HOME/starship.toml";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
      __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    };
  };

  xdg.enable = true;
}
