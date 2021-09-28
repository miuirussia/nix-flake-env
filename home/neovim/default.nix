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
      luaInit = pkgs.substituteAll { src = ./init.lua; };
    in
      ''
        source ${vimInit}
        luafile ${luaInit}
      '';

    plugins = with pkgs.vimPlugins; [
      coc-nvim

      coc-tsserver
      coc-json
      coc-yaml
      coc-git
      coc-webview
      coc-markdown-preview-enhanced

      editorconfig-vim
      fzf-vim
      fzfWrapper

      vim-better-whitespace
      vim-dhall
      vim-fugitive
      vim-json5
      vim-lastplace
      vim-nginx
      vim-purescript
      vim-rooter
      vim-sandwich
      vim-tabular
      vim-vista

      # lua plugins
      nvim-bufferline
      nvim-lualine
      nvim-matchup
      nvim-nui
      nvim-package-info
      nvim-which-key

      # icons
      nvim-web-devicons

      # tree-sitter
      nvim-treesitter
      tree-sitter-grammars

      #themes
      base16-vim
    ];
  };
}
