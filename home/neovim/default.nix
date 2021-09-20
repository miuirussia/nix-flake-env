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

      editorconfig-vim
      fzf-vim
      fzfWrapper
      haskell-vim
      vim-dhall

      {
        plugin = vim-lualine;
        config = ''
            lua << EOF
              require'lualine'.setup {
                options = {
                  icons_enabled = true,
                  theme = 'onedark',
                  component_separators = { left = '', right = ''},
                  section_separators = { left = '', right = ''},
                  disabled_filetypes = {}
                },
                sections = {
                  lualine_a = {
                    {
                      'mode',
                      separator = { left = '' },
                      padding = { left = 1, right = 2 },
                      fmt = function(str) return str:sub(1,1) end,
                    }
                  },
                  lualine_b = {'branch'},
                  lualine_c = {
                      {
                        'filename',
                        path = 1,
                        shorting_target = 40,
                      },
                      {
                        'diagnostics',
                        sources = {'coc', 'nvim'},
                      }
                  },
                  lualine_x = {'encoding', 'fileformat', 'filetype'},
                  lualine_y = {'progress'},
                  lualine_z = {
                      {
                        'location',
                        separator = { right = '' },
                        padding = { left = 2, right = 1 },
                      }
                  }
                },
                inactive_sections = {
                  lualine_a = {},
                  lualine_b = {},
                  lualine_c = {'filename'},
                  lualine_x = {'location'},
                  lualine_y = {},
                  lualine_z = {}
                },
                tabline = {},
                extensions = {'fugitive'}
              }
            EOF
        '';
      }
      vim-better-whitespace
      vim-cursorword
      vim-devicons
      vim-fugitive
      vim-js
      vim-json5
      vim-jsx-pretty
      vim-lastplace
      vim-markdown
      vim-nginx
      vim-nix
      vim-purescript
      vim-rooter
      vim-rust
      vim-sandwich
      vim-tabular
      vim-toml
      {
        plugin = vim-treesitter;
        config = ''
          lua << EOF
            require'nvim-treesitter.configs'.setup {
              ensure_installed = "maintained",
              highlight = {
                enable = true,
                disable = { "haskell" },
              },
              matchup = {
                enable = true,
              },
            }

            local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
            parser_config.typescript.used_by = {"javascript", "javascriptreact"}
          EOF
        '';
      }
      vim-vista

      #themes
      base16-vim
    ];
  };
}
