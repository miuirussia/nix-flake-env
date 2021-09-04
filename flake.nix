{
  description = "KDeveloper system config";

  inputs = {
    nixpkgs.url = "github:miuirussia/nixpkgs";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:miuirussia/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    haskell-nix.url = "github:miuirussia/haskell.nix";
    haskell-nix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, flake-utils, haskell-nix, ... }:
    let
      supportedSystem = [ "x86_64-linux" "x86_64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystem (system: f system);

      homeOverlays = let
        path = ./overlays;
      in
        with builtins;
        map (n: import (path + ("/" + n))) (
          filter
            (
              n:
                match ".*\\.nix" n != null
                || pathExists (path + ("/" + n + "/default.nix"))
            )
            (attrNames (readDir path))
        );

      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
        };
        overlays = homeOverlays ++ [
          haskell-nix.overlay
        ];
      };

      homeManagerConfig =
        { user
        , userConfig ? ./home + "/user-${user}.nix"
        , ...
        }: {
          imports = [
            userConfig
            ./home
          ];
        };

      mkDarwinModules =
        args @ { user
        , host
        , hostConfig ? ./hosts + "/host-${host}.nix"
        , ...
        }: [
          home-manager.darwinModules.home-manager
          hostConfig
          {
            nix.nixPath = {
              nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix";
            };
            nixpkgs = nixpkgsConfig;
            users.users.${user}.home = "/Users/${user}";
            home-manager.useGlobalPkgs = true;
            home-manager.users.${user} = homeManagerConfig args;
          }
        ];
    in
      {
        darwinConfigurations = {
          bootstrap = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = [
              ./shared/darwin-bootstrap.nix
            ];
          };
        };

        pkgs = forAllSystems (
          system:
            import nixpkgs {
              inherit (nixpkgsConfig) config overlays;
              inherit system;
            }
        );

      };
}
