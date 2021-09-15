{ config, pkgs, lib, ... }:

let
  tmp_directory = "/tmp";
  home_directory = "${config.home.homeDirectory}";
in
{
  imports = [
    ./git.nix
    ./kitty/default.nix
    ./neovim/default.nix
    ./starship.nix
    ./zsh/default.nix
  ];

  home = {
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "${pkgs.vim}/bin/vim";
      EMAIL = "${config.programs.git.userEmail}";
      PAGER = "${pkgs.less}/bin/less";
      CLICOLOR = true;
      GPG_TTY = "$TTY";
      PATH = "$PATH:$HOME/.local/bin:$HOME/.tfenv/bin";
    };
  };

  home.activation = {
    linkAppsAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -f $HOME/.linked-apps ]; then
        while read p; do
          $DRY_RUN_CMD rm -rf "$p"
        done < $HOME/.linked-apps
      fi
      $DRY_RUN_CMD rm -f $HOME/.linked-apps
      $DRY_RUN_CMD mkdir -p $HOME/Applications
      for f in /nix/var/nix/profiles/per-user/$USER/profile/Applications/* ; do
        if [ -d "$f" ]; then
          target="/Applications/''${f##*/}"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$f" "$target"
          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
          echo "$target" >> $HOME/.linked-apps
        fi
      done
      mv $HOME/.linked-apps $HOME/.linked-apps.unsorted
      cat $HOME/.linked-apps.unsorted | sort -u > $HOME/.linked-apps
      rm $HOME/.linked-apps.unsorted
    '';
  };

  programs = {
    home-manager = { enable = true; };

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    ssh = {
      enable = true;

      controlMaster = "auto";
      controlPath = "${tmp_directory}/ssh-%u-%r@%h:%p";
      controlPersist = "1800";

      forwardAgent = true;
      serverAliveInterval = 60;

      hashKnownHosts = true;
    };
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome = "${home_directory}/.data";
    cacheHome = "${home_directory}/.cache";
  };
}
