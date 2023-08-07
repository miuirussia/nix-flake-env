{ config, pkgs, lib, ... }:

{
  imports = [
    ./defaults.nix
  ];

  nix = {
    configureBuildUsers = true;

    gc.automatic = false;
    gc.interval = { Weekday = 5; Hour = 3; Minute = 15; }; # Thu 03:15
    gc.options = "--delete-older-than 30d";

    settings = {
      sandbox = false;
      trusted-users = [ "root" ];
    };
  };

  services = {
    nix-daemon.enable = true;
  };


  system.stateVersion = 4;

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  launchd.daemons.limit-maxproc = {
    serviceConfig.RunAtLoad = true;
    serviceConfig.ProgramArguments = [
      "launchctl"
      "limit"
      "maxproc"
      "2048"
      "2048"
    ];
    serviceConfig.Label = "limit.maxproc";
  };

  launchd.daemons.limit-maxfiles = {
    serviceConfig.RunAtLoad = true;
    serviceConfig.ProgramArguments = [
      "launchctl"
      "limit"
      "maxfiles"
      "524288"
      "524288"
    ];
    serviceConfig.Label = "limit.maxfiles";
  };
}
