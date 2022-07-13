{ config, pkgs, ... }: {
  programs.fzf = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;

    tmux.enableShellIntegration = true;
  };

  programs.zsh = {
    enable = true;

    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = false;

    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    cdpath = [
      "."
      "~"
    ];

    plugins = with pkgs.zshPlugins; [
      fast-syntax-highlighting
      zsh-history-substring-search
      zsh-yarn-completions
    ];

    shellAliases = {
      # Recursively remove Apple meta files
      cleanupds = "find . -type f -name '*.DS_Store' -ls -delete";
      cleanupad = "find . -type d -name '.AppleD*' -ls -exec /bin/rm -r {} \\;";

      wip = "g add -u && g commit -m \"wip\" && g fetch --all && g pull --rebase && g push";

      e = "nvim";
      g = "git";
      grep = "grep --color";
      password = "LC_CTYPE=C tr -dc 'A-HJ-NPR-Za-km-z2-9' < /dev/urandom | head -c 16";
      clc = "clear && printf \"\\033[3J\"";
      srv = "pnpx -y serve";
      kssh = "kitty +kitten ssh";

      ":r" = "exec $SHELL -l";
      ":q" = "exit";
    };

    defaultKeymap = "viins";
    dotDir = ".config/zsh";

    envExtra = ''
      export LC_ALL="en_US.UTF-8";
      export LANG="en_US.UTF-8";

      CABAL="$HOME/.cabal/bin"
      CARGO="$HOME/.cargo/bin"
      DOT_LOCAL="$HOME/.local/bin"
      LOCAL="/usr/local/bin"
      PYTHON="/usr/local/opt/python/libexec/bin"
      SBIN="/usr/local/sbin"
      YARN="$HOME/.yarn/bin"
      YARN_NM="$XDG_CONFIG_HOME/yarn/global/node_modules/.bin"
      export PATH="$DOT_LOCAL:$CARGO:$CABAL:$YARN:$YARN_NM:$PYTHON:$LOCAL:$SBIN:$PATH"
      export HOMEBREW_NO_ANALYTICS=1
      export HOMEBREW_BUNDLE_NO_LOCK=1
      export NVIM_LOG_FILE=/dev/null
    '';

    profileExtra = ''
      export GPG_TTY=$(tty)
    '';

    initExtra = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      export KEYTIMEOUT=1

      vi-search-fix() {
        zle vi-cmd-mode
        zle .vi-history-search-backward
      }

      autoload vi-search-fix
      zle -N vi-search-fix
      bindkey -M viins '\e/' vi-search-fix

      bindkey "^?" backward-delete-char

      resume() {
        fg
        zle push-input
        BUFFER=""
        zle accept-line
      }
      zle -N resume
      bindkey "^Z" resume

      function ls() {
        ${pkgs.coreutils}/bin/ls --color=auto --group-directories-first "$@"
      }

      # Get gzipped file size
      function gz {
        local ORIGSIZE=$(wc -c < "$1")
        local GZIPSIZE=$(gzip -c "$1" | wc -c)
        local RATIO=$(echo "$GZIPSIZE * 100/ $ORIGSIZE" | bc -l)
        local SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100/ $ORIGSIZE" | bc -l)
        printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" "$ORIGSIZE" "$GZIPSIZE" "$SAVED" "$RATIO"
      }

      timestamp() {
        if [ $# -ne 1 ];
        then
          echo $(( EPOCHSECONDS ))
        else
          date -d @$1
        fi
      }

      # Get IP from hostname
      function hostname2ip {
        ping -c 1 "$1" | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
      }

      # mkdir and cd into it
      function mk {
        mkdir -p $@ && cd $_;
      }

      # Base16 Shell
      BASE16_SHELL="${pkgs.base16-shell}/opt/base16-shell/"
      [ -n "$PS1" ] && \
          [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
              eval "$("$BASE16_SHELL/profile_helper.sh")"

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';
  };
}
