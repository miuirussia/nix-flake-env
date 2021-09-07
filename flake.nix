{
  description = "KDeveloper system config";

  inputs = {
    nixpkgs = { url = "github:miuirussia/nixpkgs/nixpkgs-unstable"; };

    hackage = { url = "github:miuirussia/hackage.nix"; flake = false; };
    stackage = { url = "github:input-output-hk/stackage.nix"; flake = false; };

    darwin = { url = "github:LnL7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:miuirussia/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };

    haskell-nix = {
      url = "github:miuirussia/haskell.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hackage.follows = "hackage";
        stackage.follows = "stackage";
      };
    };

    jetbrains-mono = { url = "github:JetBrains/JetBrainsMono"; flake = false; };
    hls-nix = { url = "github:miuirussia/hls-nix"; flake = false; };
    tree-sitter = { url = "github:tree-sitter/tree-sitter"; flake = false; };

    neovim = { url = "github:neovim/neovim"; flake = false; };
    coc-nvim = { url = "github:neoclide/coc.nvim/release"; flake = false; };

    vim-airline = { url = "github:vim-airline/vim-airline"; flake = false; };
    vim-airline-themes = { url = "github:vim-airline/vim-airline-themes"; flake = false; };
    vim-dhall = { url = "github:vmchale/dhall-vim"; flake = false; };
    vim-js = { url = "github:yuezk/vim-js"; flake = false; };
    vim-json5 = { url = "github:gutenye/json5.vim"; flake = false; };
    vim-jsx-pretty = { url = "github:maxmellon/vim-jsx-pretty"; flake = false; };
    vim-nginx = { url = "github:chr4/nginx.vim"; flake = false; };
    vim-purescript = { url = "github:purescript-contrib/purescript-vim"; flake = false; };
    vim-rooter = { url = "github:airblade/vim-rooter"; flake = false; };
    vim-rust = { url = "github:rust-lang/rust.vim"; flake = false; };
    vim-sandwich = { url = "github:machakann/vim-sandwich"; flake = false; };
    vim-styled-components = { url = "github:styled-components/vim-styled-components"; flake = false; };
    vim-tabular = { url = "github:godlygeek/tabular"; flake = false; };
    vim-toml = { url = "github:cespare/vim-toml"; flake = false; };
    vim-vista = { url = "github:liuchengxu/vista.vim"; flake = false; };

    flake-utils = { url = "github:numtide/flake-utils"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, flake-utils, haskell-nix, ... }:
    let
      supportedSystem = [ "x86_64-linux" "x86_64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystem (system: f system);

      nixpkgsOverlays = let
        path = ./overlays;
      in
        with builtins;
        map (n: (import (path + ("/" + n)) inputs)) (
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
        overlays = nixpkgsOverlays ++ [
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
          ./shared/darwin.nix
          ./shared/tmux.nix
          hostConfig
          {
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

          ghActions = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = mkDarwinModules {
              user = "runner";
              host = "mac-gh";
            };
          };

          home = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = mkDarwinModules {
              user = "kirill";
              host = "kirill-imac";
            };
          };

          macbook = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = mkDarwinModules {
              user = "kirill";
              host = "kirill-macbook";
            };
          };

          work = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = mkDarwinModules {
              user = "kirill";
              host = "kkuznetsov";
            };
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
