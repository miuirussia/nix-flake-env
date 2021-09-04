{ config, pkgs, lib, ... }:

let
  tmp_directory = "/tmp";
  home_directory = "${config.home.homeDirectory}";
in {
  imports = [
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

    packages = with pkgs; [
    ];
  };

  programs = {
    home-manager = { enable = true; };
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome = "${home_directory}/.data";
    cacheHome = "${home_directory}/.cache";
  };
}
