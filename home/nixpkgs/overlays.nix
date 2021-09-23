let
  nix-flake-env = import <nix-flake-env>;
in
  nix-flake-env.pkgs.${builtins.currentSystem}.overlays
