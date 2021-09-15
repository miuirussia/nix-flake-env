{ config, pkgs, lib, ... }:

{
  imports = [
    ./defaults.nix
  ];

  nix = {
    useSandbox = false;
    gc.automatic = false;
    gc.interval = { Weekday = 5; Hour = 3; Minute = 15; }; # Thu 03:15
    gc.options = "--delete-older-than 30d";
    trustedUsers = [ "root" ];
  };

  services = {
    nix-daemon.enable = true;
  };

  users.nix.configureBuildUsers = true;

  system.stateVersion = 4;
}
