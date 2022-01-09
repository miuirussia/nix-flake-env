{ config, pkgs, ... }: {
  programs.neovim = let
    dependencies = {
      sumneko_lua_language_server = pkgs.sumneko-lua-language-server;
      flow = pkgs.flow;
      haskell_language_server_wrapper = pkgs.hls;
      rnix_lsp = pkgs.rnix-lsp;
      typescript_language_server = pkgs.nodePackages.typescript-language-server;
      eslint_d = pkgs.nodePackages.eslint_d;
      shellcheck = pkgs.shellcheck;
      prettier = pkgs.nodePackages.prettier;
      stylua = pkgs.stylua;
      diagnosticls = pkgs.nodePackages.diagnostic-languageserver;
      rust_analyzer = pkgs.rust-analyzer-nightly;
    };

    nvim-kdevlab-luaconfig = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "nvim-kdevlab-luaconfig";
      version = "0.0.0";

      buildInputs = pkgs.lib.mapAttrsToList (name: value: value) dependencies;

      src = pkgs.writeTextFile {
        name = "init.lua";
        destination = "/lua/nvim-kdevlab-luaconfig/init.lua";
        text = builtins.readFile (
          pkgs.substituteAll (
            {
              src = ./init.lua;
            } // dependencies
          )
        );
      };
    };
  in
    {
      enable = true;

      package = pkgs.neovim-nightly;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      extraPackages = with pkgs; [
        (yarn.override { nodejs = nodejs; })
        fd
        git
        nodejs
        ripgrep
        tree-sitter
      ];

      extraPython3Packages = (
        ps: with ps; [
          black
          flake8
          jedi
        ]
      );

      extraConfig = let
        vimInit = pkgs.substituteAll { src = ./init.vim; };
      in
        ''
          source ${vimInit}
          lua require('impatient')
          lua require('nvim-kdevlab-luaconfig')
        '';

      plugins = with pkgs.vimPlugins; [
        nvim-kdevlab-luaconfig

        editorconfig-vim
        telescope-fzf-native-nvim

        vim-better-whitespace
        vim-dhall
        vim-json5
        vim-lastplace
        vim-nginx
        vim-purescript
        vim-rooter
        vim-sandwich
        vim-tabular

        # lua utils
        nvim-impatient
        nvim-nui
        nvim-plenary

        # lua plugins
        nvim-actionmenu
        nvim-bufferline
        nvim-cmp
        nvim-cmp-buffer
        nvim-cmp-lsp
        nvim-cmp-path
        nvim-cmp-vsnip
        nvim-crates
        nvim-dap
        nvim-fzf
        nvim-gitsigns
        nvim-gps
        nvim-lightbulb
        nvim-lsp-colors
        nvim-lspconfig
        nvim-lspkind
        nvim-lualine
        nvim-lualine-lsp-progress
        nvim-matchup
        nvim-notify
        nvim-null-ls
        nvim-package-info
        nvim-rust-tools
        nvim-telescope
        nvim-trouble
        nvim-vsnip
        nvim-which-key

        # icons
        nvim-web-devicons

        # tree-sitter
        nvim-treesitter
        tree-sitter-grammars

        # themes
        nvim-onedark
      ];
    };
}
