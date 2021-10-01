{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;

    package = pkgs.neovim-nightly;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      nodejs
      (yarn.override { nodejs = nodejs; })
      git
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
      luaInit = pkgs.substituteAll {
        src = ./init.lua;

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
      };
    in
      ''
        source ${vimInit}
        luafile ${luaInit}
      '';

    plugins = with pkgs.vimPlugins; [
      editorconfig-vim

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
      nvim-nui
      nvim-plenary

      # lua plugins
      nvim-bufferline
      nvim-cmp
      nvim-cmp-buffer
      nvim-cmp-lsp
      nvim-cmp-path
      nvim-cmp-vsnip
      nvim-gitsigns
      nvim-gps
      nvim-lsp-colors
      nvim-lspconfig
      nvim-lspkind
      nvim-lspstatus
      nvim-lualine
      nvim-matchup
      nvim-notify
      nvim-null-ls
      nvim-package-info
      nvim-telescope
      nvim-trouble
      nvim-vsnip
      nvim-which-key

      # icons
      nvim-web-devicons

      # tree-sitter
      nvim-treesitter
      tree-sitter-grammars

      #themes
      nvim-onedark
    ];
  };
}
