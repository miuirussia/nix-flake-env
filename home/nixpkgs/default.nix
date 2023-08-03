{ config, pkgs, inputs, ... }: {
  home.file.".config/nixpkgs/overlays.nix".text = ''
   let
     configuration = import ${inputs.self};
   in
   [ configuration.overlay ]
  '';
}
