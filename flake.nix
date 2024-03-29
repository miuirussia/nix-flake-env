{
  description = "KDeveloper system config";

  inputs = {
    nixpkgs = { url = "github:miuirussia/nixpkgs"; };
    nixUnstable.url = "github:NixOS/nix/a1fdc68c655e8d7ece51b6c84796d35203386c87";
    fenix = { url = "github:nix-community/fenix"; inputs.nixpkgs.follows = "nixpkgs"; };

    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # spdx
    spdx = { url = "github:phadej/spdx/7fbc0ee05d23be122f7e61c54514f4b309b0dda3"; flake = false; };

    # dotenv management
    darwin = { url = "github:LnL7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };

    # fonts
    jetbrains-mono = { url = "github:JetBrains/JetBrainsMono"; flake = false; };

    # zsh plugins
    base16-shell = { url = "github:chriskempson/base16-shell"; flake = false; };
    zsh-syntax-highlighting = { url = "github:zsh-users/zsh-syntax-highlighting"; flake = false; };
    fast-syntax-highlighting = { url = "github:zdharma-continuum/fast-syntax-highlighting"; flake = false; };
    zsh-history-substring-search = { url = "github:zsh-users/zsh-history-substring-search"; flake = false; };
    zsh-nix-shell = { url = "github:chisui/zsh-nix-shell"; flake = false; };
    zsh-yarn-completions = { url = "github:chrisands/zsh-yarn-completions"; flake = false; };

    # neovim
    neovim-nightly = {
      url = "github:neovim/neovim/nightly?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-onedark = { url = "github:navarasu/onedark.nvim"; flake = false; };

    vim-dhall = { url = "github:vmchale/dhall-vim"; flake = false; };
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
    nvim-bufferline = { url = "github:akinsho/bufferline.nvim"; flake = false; };
    nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    nvim-cmp-buffer = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
    nvim-cmp-lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
    nvim-cmp-path = { url = "github:hrsh7th/cmp-path"; flake = false; };
    nvim-cmp-vsnip = { url = "github:hrsh7th/cmp-vsnip"; flake = false; };
    nvim-crates = { url = "github:saecki/crates.nvim"; flake = false; };
    nvim-dap = { url = "github:mfussenegger/nvim-dap"; flake = false; };
    nvim-gitsigns = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    nvim-gps = { url = "github:SmiteshP/nvim-gps"; flake = false; };
    nvim-impatient = { url = "github:lewis6991/impatient.nvim"; flake = false; };
    nvim-lightbulb = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    nvim-lsp-colors = { url = "github:folke/lsp-colors.nvim"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    nvim-lspkind = { url = "github:onsails/lspkind-nvim"; flake = false; };
    nvim-lualine = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };
    nvim-lualine-lsp-progress = { url = "github:arkav/lualine-lsp-progress"; flake = false; };
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

  outputs = inputs @ { self, agenix, nixpkgs, darwin, home-manager, fenix, flake-utils, ... }:
    let
      supportedSystem = [ "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystem (system: f system);

      composeExtensions = f: g: final: prev:
        let
          fApplied = f final prev;
          prev' = prev // fApplied;
        in
        fApplied // g final prev';

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

      overlays = nixpkgsOverlays ++ [
        fenix.overlays.default
      ];

      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
        };
        inherit overlays;
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
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.users.${user} = homeManagerConfig args;
            networking = {
              computerName = host;
              hostName = host;
              localHostName = host;
            };
          }
          {
            environment.systemPackages = [ agenix.packages.x86_64-darwin.default ];
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

        work = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = mkDarwinModules {
            user = "kirill";
            host = "kkuznetsov";
          };
          system = "x86_64-darwin";
        };
      };

      overlay = builtins.foldl' composeExtensions (_: _: { }) overlays;

      apps = forAllSystems (system: {
        update = with nixpkgs.legacyPackages.${system}; {
          type = "app";
          program = "${(writeShellScript "update" ''
            echo "Update apple fonts..."
            (cd overlays/fonts && ./apple-update)
            echo "Update vscode plugins..."
            (cd overlays/vscode && ./update-vscode-plugins.py)
            echo "Update node modules..."
            (cd overlays/nodePackages/lib && ${node2nix}/bin/node2nix -i node-packages.json -18)
          '')}";
        };
      });

      pkgs = forAllSystems (
        system:
        import nixpkgs {
          inherit (nixpkgsConfig) config overlays;
          inherit system;
        }
      );

    };
}
