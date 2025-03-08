{
  config,
  lib,
  pkgs,
  ...
}: {
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "viins";
      dotDir = ".config/zsh";

      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        path = "${config.xdg.cacheHome}/zsh/history";
        save = 25000;
        size = 25000;
        share = true;
      };

      envExtra = ''
        # Add recursively $XDG_BIN_HOME to path.
        # That means that if you have $XDG_BIN_HOME/dir, that dir will also get added
        export PATH="''${CARGO_HOME}/bin:''${GOPATH}/bin:$PATH"
      '';

      completionInit = ''
        autoload -Uz compinit
        zmodload zsh/complist
        # Enable completion caching since big commands (like emerge) can take quite some
        # time to load all the possible completions.
        compinit -d $XDG_CACHE_HOME/zsh/zcompdump
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/compcache"

        zstyle ':completion:*' completer _extensions _complete _approximate _expand_alias
        zstyle ':completion:*' menu select
        # Custom styles for messages above completion menu
        zstyle ':completion:*:descriptions' format '%F{blue}->%f %BCompleting%b: %F{blue}%d%f'
        zstyle ':completion:*:corrections'  format '(%BErrors%b: %F{red}%e%f)'
        zstyle ':completion:*:messages'	    format '%F{purple}==%f %d'
        zstyle ':completion:*:warnings'     format '%F{yellow}->%f No matches: %d'
        # Sorters
        zstyle ':completion:*' file-sort modification
        zstyle ':completion:*' file-list all
        zstyle ':completion:*:paths' path-completion yes
        zstyle ':completion:*:*:cd:*' ignore-parents parent pwd
        zstyle ':completion:*:manuals' separate-sections true
        zstyle ':completion:*:manuals.(^1*)' insert-sections true

        # SSH/SCP/RSYNC completion
        # thank you @hlissner
        zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
        zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
        zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
        zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
        zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
        zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
        zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

        # Squeeze two slashes in / ("//" -> "/") like most unix systems.
        zstyle ':completion:*' squeeze-slashes true
        # Do a case insensitive completion and reload it live.
        zstyle ':completion:*' matcher-list ' ' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        # Styling for the kill command. (Taken from github:Awan/cfg)
        zstyle ':completion::*:kill:*:*' command 'ps x -U $USER -o pid,%cpu,cmd'
        zstyle ':completion::*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

        # The following allows to navigate the completion menu with HJKL (vim) keys.
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'j' vi-down-line-or-history
        bindkey -M menuselect 'l' vi-forward-char

        # Like my neovim configuration, Ctrl-Space opens a completion menu
        bindkey '^ ' complete-word
      '';

      initExtra = ''
        setopt AUTO_CD
        setopt AUTO_LIST
        setopt AUTO_PARAM_SLASH
        setopt AUTO_REMOVE_SLASH
        setopt EXTENDED_GLOB
        unsetopt LIST_BEEP
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStringsSep "$" [
          "$directory" # needs $ otherwise doesn't work
          "git_branch"
          "git_metrics"
          "cmd_duration"
          "jobs"
          "nix_shell"
          "character"
        ];

        git_metrics.disabled = false;
        nix_shell.heuristic = true;

        directory = {
          style = "blue";
          truncation_length = 5;
        };

        character = {
          success_symbol = "[|](237)";
          error_symbol = "[!](red)";
          vimcmd_symbol = "[|](cyan)";
        };

        git_branch = {
          format = "[$symbol(:$remote_branch)]($style) $branch ";
          symbol = "";
        };

        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          stashed = "≡";
        };

        git_state = {
          format = "\([$state( $progress_current/$progress_total)]($style)\) ";
          style = "bright-black";
        };

        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
      };
    };
  };

  home.shellAliases = {
    rm = "rm -vdI";
    cp = "cp -vpR";
    df = "df -h";
    mv = "mv -fv";
    mkdir = "mkdir -pv";
    less = "less --use-color --color=NK- --force --ignore-case --incsearch -N";
    grep = "grep --extended-regexp --with-filename --color=always";
    ip = "ip -h -s --color=always";
    diff = "diff -t --color=always";
    nmt = "nmtui-connect";
    pm = "pulsemixer";
    # vim = config.home.sessionVariables.EDITOR;
  };
}
