{
  description = "KDeveloper system config";

  inputs = {
    nixpkgs = { url = "github:miuirussia/nixpkgs/nixpkgs-unstable"; };

    hackage = { url = "github:miuirussia/hackage.nix"; flake = false; };
    stackage = { url = "github:input-output-hk/stackage.nix"; flake = false; };

    darwin = { url = "github:LnL7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };

    haskell-nix = {
      url = "github:input-output-hk/haskell.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hackage.follows = "hackage";
        stackage.follows = "stackage";
      };
    };
    hls-nix = {
      url = "github:miuirussia/hls-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hackage.follows = "hackage";
        stackage.follows = "stackage";
        haskell-nix.follows = "haskell-nix";
        hls-unstable.follows = "hls-unstable";
      };
    };

    jetbrains-mono = { url = "github:JetBrains/JetBrainsMono"; flake = false; };
    tree-sitter = { url = "github:tree-sitter/tree-sitter"; flake = false; };
    hls-unstable = { url = "github:haskell/haskell-language-server"; flake = false; };

    # zsh plugins
    base16-shell = { url = "github:chriskempson/base16-shell"; flake = false; };
    zsh-syntax-highlighting = { url = "github:zsh-users/zsh-syntax-highlighting"; flake = false; };
    fast-syntax-highlighting = { url = "github:zdharma/fast-syntax-highlighting"; flake = false; };
    zsh-history-substring-search = { url = "github:zsh-users/zsh-history-substring-search"; flake = false; };

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
    vim-yats = { url = "github:herringtondarkholme/yats.vim"; flake = false; };

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
        , userConfig ? ./home + "/user-${user}/default.nix"
        , host
        , hostOverride ? ./hosts + "/host-${host}/user-${user}.nix"
        , ...
        }: {
          imports = [
            userConfig
            ./home
          ] ++ nixpkgs.lib.optional (builtins.pathExists hostOverride) hostOverride;
        };

      mkDarwinModules =
        args @ { user
        , host
        , hostConfig ? ./hosts + "/host-${host}/default.nix"
        , ...
        }: [
          home-manager.darwinModules.home-manager
          ./hosts/darwin.nix
          ./hosts/tmux.nix
          hostConfig
          {
            nixpkgs = nixpkgsConfig;
            users.users.${user}.home = "/Users/${user}";
            home-manager.useGlobalPkgs = true;
            home-manager.users.${user} = homeManagerConfig args;
            networking = {
              computerName = host;
              hostName = host;
              localHostName = host;
            };
          }
        ];
    in
      {
        darwinConfigurations = {
          bootstrap = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = [
              ./hosts/darwin-bootstrap.nix
            ];
            system = "x86_64-darwin";
          };

          ghActions = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = mkDarwinModules {
              user = "runner";
              host = "mac-gh";
            };
            system = "x86_64-darwin";
          };

          home = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = mkDarwinModules {
              user = "kirill";
              host = "kirill-imac";
            };
            system = "x86_64-darwin";
          };

          macbook = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = mkDarwinModules {
              user = "kirill";
              host = "kirill-macbook";
            };
            system = "x86_64-darwin";
          };

          work = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = mkDarwinModules {
              user = "kirill";
              host = "kkuznetsov";
            };
            system = "x86_64-darwin";
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
