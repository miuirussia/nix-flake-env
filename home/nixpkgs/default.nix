{ config, pkgs, ... }: {
  home.file.".config/nixpkgs/overlays.nix".source = ./overlays.nix;
}
