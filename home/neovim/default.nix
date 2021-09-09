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

    extraConfig = builtins.readFile ./vimrc;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = coc-nvim;
        config = ''
          nmap <silent> [ <Plug>(coc-diagnostic-prev)
          nmap <silent> ] <Plug>(coc-diagnostic-next)
          function! s:show_documentation()
            if (index(['vim','help'], &filetype) >= 0)
              execute 'h '.expand('<cword>')
            else
              call CocAction('doHover')
            endif
          endfunction
          nmap <silent> [lsp]a  :<C-u>CocAction<cr>
          nmap <silent> [lsp]c  :<C-u>CocCommand<cr>
          nmap <silent> [lsp]D  :<C-u>CocDiagnostics<cr>
          nmap <silent> [lsp]E  :<C-u>CocList extensions<cr>
          nmap <silent> [lsp]l  :<C-u>CocList location<cr>
          nmap <silent> [lsp]s  :<C-u>CocList services<cr>
          autocmd FileType purescript nmap <silent> [lsp]b  :<C-u>CocCommand purescript.build<cr>
          nmap <silent> [lsp]d   <Plug>(coc-definition)
          nmap <silent> [lsp]y   <Plug>(coc-type-definition)
          nmap <silent> [lsp]i   <Plug>(coc-implementation)
          nmap <silent> [lsp]r   <Plug>(coc-rename)
          nmap <silent> [lsp]R   <Plug>(coc-references)
          nmap <silent> [lsp]ca  <Plug>(coc-codeaction)
          nmap <silent> [lsp]f   <Plug>(coc-format)
          nmap <silent> [lsp]h  :<C-u>call <SID>show_documentation()<cr>
          let g:airline#extensions#coc#enabled = 1
        '';
      }
      coc-tsserver
      coc-json
      coc-yaml
      coc-git
      coc-webview
      coc-markdown-preview-enhanced

      vim-dhall
      editorconfig-vim
      fzf-vim
      fzfWrapper
      haskell-vim

      vim-nginx
      vim-purescript
      vim-tabular
      {
        plugin = vim-airline;
        config = ''
          let g:airline_powerline_fonts                    = 1
          let g:airline#extensions#lsp#enabled             = 1
          let g:airline#extensions#tabline#enabled         = 1
          let g:airline#extensions#branch#enabled          = 0
          let g:airline#extensions#keymap#enabled          = 0
          let g:airline#extensions#tagbar#enabled          = 1
          let g:airline_exclude_preview                    = 1
          let g:airline_mode_map                           = {} " :h mode()
          let g:airline_mode_map['!']                      = '!'
          let g:airline_mode_map['__']                     = '-'
          let g:airline_mode_map['c']                      = 'C'
          let g:airline_mode_map['i']                      = 'I'
          let g:airline_mode_map['ic']                     = 'IC'
          let g:airline_mode_map['ix']                     = 'IC'
          let g:airline_mode_map['n']                      = 'N'
          let g:airline_mode_map['ni']                     = '(I)'
          let g:airline_mode_map['no']                     = 'OP'
          let g:airline_mode_map['r']                      = 'CR'
          let g:airline_mode_map['rm']                     = 'M'
          let g:airline_mode_map['r?']                     = '?'
          let g:airline_mode_map['R']                      = 'R'
          let g:airline_mode_map['Rv']                     = 'VR'
          let g:airline_mode_map['Rx']                     = 'RX'
          let g:airline_mode_map['s']                      = 'S'
          let g:airline_mode_map['S']                      = 'SL'
          let g:airline_mode_map['']                     = 'SB'
          let g:airline_mode_map['t']                      = 'T'
          let g:airline_mode_map['v']                      = 'V'
          let g:airline_mode_map['V']                      = 'VL'
          let g:airline_mode_map['']                     = 'VB'
        '';
      }
      vim-airline-themes
      vim-better-whitespace
      vim-cursorword
      vim-devicons
      vim-fugitive
      vim-js
      vim-json5
      vim-jsx-pretty
      vim-lastplace
      vim-markdown
      vim-nix
      vim-rooter
      vim-rust
      vim-sandwich
      vim-toml
      vim-yats
      vim-vista

      #themes
      base16-vim
    ];
  };
}
