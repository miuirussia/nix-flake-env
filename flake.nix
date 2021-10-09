{
  description = "KDeveloper system config";

  inputs = {
    nixpkgs = { url = "github:miuirussia/nixpkgs/nixpkgs-unstable"; };
    fenix = { url = "github:nix-community/fenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixUnstable = { url = "github:NixOS/nix/6bd74a6beaabcf8fe73d2d48894f9870648e0eb1"; inputs.nixpkgs.follows = "nixpkgs"; };

    # dotenv management
    darwin = { url = "github:LnL7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };

    # haskell-nix
    hackage = { url = "github:miuirussia/hackage.nix"; flake = false; };
    stackage = { url = "github:input-output-hk/stackage.nix"; flake = false; };
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
      };
    };

    # fonts
    jetbrains-mono = { url = "github:JetBrains/JetBrainsMono"; flake = false; };

    # zsh plugins
    base16-shell = { url = "github:chriskempson/base16-shell"; flake = false; };
    zsh-syntax-highlighting = { url = "github:zsh-users/zsh-syntax-highlighting"; flake = false; };
    fast-syntax-highlighting = { url = "github:zdharma/fast-syntax-highlighting"; flake = false; };
    zsh-history-substring-search = { url = "github:zsh-users/zsh-history-substring-search"; flake = false; };

    # neovim
    neovim = { url = "github:neovim/neovim"; flake = false; };
    tree-sitter = { url = "github:tree-sitter/tree-sitter"; flake = false; };

    vim-dhall = { url = "github:vmchale/dhall-vim"; flake = false; };
    vim-edge = { url = "github:sainnhe/edge"; flake = false; };
    vim-haskell = { url = "github:neovimhaskell/haskell-vim"; flake = false; };
    vim-js = { url = "github:yuezk/vim-js"; flake = false; };
    vim-json5 = { url = "github:gutenye/json5.vim"; flake = false; };
    vim-jsx-pretty = { url = "github:maxmellon/vim-jsx-pretty"; flake = false; };
    vim-nginx = { url = "github:chr4/nginx.vim"; flake = false; };
    vim-purescript = { url = "github:purescript-contrib/purescript-vim"; flake = false; };
    vim-rooter = { url = "github:airblade/vim-rooter"; flake = false; };
    vim-rust = { url = "github:rust-lang/rust.vim"; flake = false; };
    vim-sandwich = { url = "github:machakann/vim-sandwich"; flake = false; };
    vim-tabular = { url = "github:godlygeek/tabular"; flake = false; };
    vim-toml = { url = "github:cespare/vim-toml"; flake = false; };
    vim-typescript = { url = "github:herringtondarkholme/yats.vim"; flake = false; };

    nvim-actionmenu = { url = "github:weilbith/nvim-code-action-menu"; flake = false; };
    nvim-base16 = { url = "github:RRethy/nvim-base16"; flake = false; };
    nvim-bufferline = { url = "github:akinsho/bufferline.nvim"; flake = false; };
    nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    nvim-cmp-buffer = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
    nvim-cmp-lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
    nvim-cmp-path = { url = "github:hrsh7th/cmp-path"; flake = false; };
    nvim-cmp-vsnip = { url = "github:hrsh7th/cmp-vsnip"; flake = false; };
    nvim-dap = { url = "github:mfussenegger/nvim-dap"; flake = false; };
    nvim-gitsigns = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    nvim-gps = { url = "github:SmiteshP/nvim-gps"; flake = false; };
    nvim-impatient = { url = "github:lewis6991/impatient.nvim"; flake = false; };
    nvim-lightbulb = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    nvim-lsp-colors = { url = "github:folke/lsp-colors.nvim"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    nvim-lspkind = { url = "github:onsails/lspkind-nvim"; flake = false; };
    nvim-lspstatus = { url = "github:nvim-lua/lsp-status.nvim"; flake = false; };
    nvim-lualine = { url = "github:shadmansaleh/lualine.nvim"; flake = false; };
    nvim-matchup = { url = "github:andymass/vim-matchup"; flake = false; };
    nvim-notify = { url = "github:rcarriga/nvim-notify"; flake = false; };
    nvim-nui = { url = "github:MunifTanjim/nui.nvim"; flake = false; };
    nvim-null-ls = { url = "github:jose-elias-alvarez/null-ls.nvim"; flake = false; };
    nvim-package-info = { url = "github:vuki656/package-info.nvim"; flake = false; };
    nvim-plenary = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    nvim-rust-tools = { url = "github:simrat39/rust-tools.nvim"; flake = false; };
    nvim-telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    nvim-trouble = { url = "github:folke/trouble.nvim"; flake = false; };
    nvim-vsnip = { url = "github:hrsh7th/vim-vsnip"; flake = false; };
    nvim-web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };

    # flakes
    flake-utils = { url = "github:numtide/flake-utils"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, flake-utils, fenix, haskell-nix, ... }:
    let
      supportedSystem = [ "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystem (system: f system);

      nixpkgsOverlays =
        let
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
          fenix.overlay
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
        , hostLink ? host
        , hostConfig ? ./hosts + "/host-${hostLink}/default.nix"
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
            hostLink = "kirill-imac";
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
