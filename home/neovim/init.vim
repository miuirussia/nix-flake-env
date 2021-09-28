" Save undo info
let s:undo_dir = expand('~/.config/nvim/undo')
if !isdirectory(s:undo_dir)
  call mkdir(s:undo_dir, 'p')
endif

let s:backup_dir = expand('~/.config/nvim/backups')
if !isdirectory(s:backup_dir)
  call mkdir(s:backup_dir, 'p')
endif

let s:directory_dir = expand('~/.config/nvim/swaps')
if !isdirectory(s:directory_dir)
  call mkdir(s:directory_dir, 'p')
endif

let s:logs_dir = expand('~/.config/nvim/logs')
if !isdirectory(s:logs_dir)
  call mkdir(s:logs_dir, 'p')
endif

execute 'set undodir=' . s:undo_dir
execute 'set backupdir=' . s:backup_dir
execute 'set directory=' . s:directory_dir

" not compatible with vi
set nocompatible

""http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
" works only for OS X
let os=substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
  set clipboard^=unnamed
  set clipboard^=unnamedplus"
endif

" remap leader
" map leader key to space
let g:mapleader = ","
let g:maplocalleader = ","

" quicker access to commands
nnoremap ; :
nnoremap Q <nop>

" highlight problematic whitespace
highlight WhitespaceErrors ctermbg=Red guibg=#ff6a6a
autocmd BufEnter * match WhitespaceErrors /\s\+$\|[^\t]\@<=\t\+/

nnoremap <expr><silent> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$

" Just go out in insert mode
imap jk <ESC>l

" plugin settings

augroup vimrcEx
  autocmd!
  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{babel,jscs,jshint,eslint,stylelint}rc set filetype=json
  autocmd BufRead,BufNewFile *.cssm set filetype=css

  autocmd FocusLost * :wa
augroup END

" Theme
syntax enable
set termguicolors
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace

function! s:base16_customize() abort
  call Base16hi("CursorLineNr", g:base16_gui04, g:base16_gui01, g:base16_cterm04, g:base16_cterm01, 'bold')
  call Base16hi("Comment", g:base16_gui03, '', g:base16_cterm03, '', 'italic')
  call Base16hi('TabLineSel', g:base16_gui0B, g:base16_gui01, g:base16_cterm0B, g:base16_cterm01, 'bold')
  call Base16hi('TabLine', g:base16_gui03, g:base16_gui01, g:base16_cterm03, g:base16_cterm01, '')

  call Base16hi('CocErrorSign', g:base16_gui08, g:base16_gui01, g:base16_cterm08, g:base16_cterm01)
  call Base16hi('CocWarningSign', g:base16_gui0A, g:base16_gui01, g:base16_cterm0A, g:base16_cterm01)
  call Base16hi('CocInfoSign', g:base16_gui0D, g:base16_gui01, g:base16_cterm0D, g:base16_cterm01)
  call Base16hi('CocHintSign', g:base16_gui0E, g:base16_gui01, g:base16_cterm0E, g:base16_cterm01)

  call Base16hi('CocErrorHighlight', g:base16_gui08, '', '', '', 'undercurl')
  call Base16hi('CocWarningHighlight', g:base16_gui0A, '', '', '', 'undercurl')
  call Base16hi('CocInfoHighlight', g:base16_gui0D, '', '', '', 'undercurl')
  call Base16hi('CocHintHighlight', g:base16_gui0E, '', '', '', 'undercurl')

  call Base16hi('CocErrorVirtualText', g:base16_gui08, '', '', '')
  call Base16hi('CocWarningVirtualText', g:base16_gui0A, '', '', '')
  call Base16hi('CocInfoVirtualText', g:base16_gui0D, '', '', '')
  call Base16hi('CocHintVirtualText', g:base16_gui0E, '', '', '')

  call Base16hi('CocErrorFloat', g:base16_gui08, '', '', '')
  call Base16hi('CocWarningFloat', g:base16_gui0A, '', '', '')
  call Base16hi('CocInfoFloat', g:base16_gui0D, '', '', '')
  call Base16hi('CocHintFloat', g:base16_gui0E, '', '', '')

  call Base16hi('CocUnderline', '', '', '', '', 'undercurl')
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

colorscheme base16-onedark

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,**/node_modules/*,**/flow-typed/*

" jsx
let g:jsx_ext_required       = 0

" Tab for formatting
vnoremap <Tab> :'<,'>Tab /

let g:markdown_fenced_languages = ['typescript=javascript', 'flow=javascript.jsx']

let g:vimspector_enable_mappings = 'HUMAN'
let g:better_whitespace_enabled  = 1
let g:strip_whitespace_on_save   = 1

" Customize fzf colors to match your color scheme
let g:fzf_colors =
      \ { 'fg'      : ['fg', 'Normal'],
      \   'bg'      : ['bg', 'Normal'],
      \   'hl'      : ['fg', 'Comment'],
      \   'fg+'     : ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \   'bg+'     : ['bg', 'CursorLine', 'CursorColumn'],
      \   'hl+'     : ['fg', 'Statement'],
      \   'info'    : ['fg', 'PreProc'],
      \   'border'  : ['fg', 'Ignore'],
      \   'prompt'  : ['fg', 'Conditional'],
      \   'pointer' : ['fg', 'Exception'],
      \   'marker'  : ['fg', 'Keyword'],
      \   'spinner' : ['fg', 'Label'],
      \   'header'  : ['fg', 'Comment'] }

" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse --border'

" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingWindow()' }

" Function to create the custom floating window
function! FloatingWindow()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)

  " 50% of the height
  let height = float2nr(&lines * 0.5)
  " 60% of the height
  let width = float2nr(&columns * 0.6)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (one line down of the top)
  let vertical = float2nr((&lines - height) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  " Tried setting colors here with nvim_win_set_option, but fzf overrides it.
  " See the autocmd down at the bottom.
  return nvim_open_win(buf, v:true, opts)
endfunction

let g:rooter_patterns = ['bower.json', 'psc-package.json', 'spago.dhall', '.flowconfig', 'package.json', '.git/']

function! ToggleVerbose()
  if !&verbose
    set verbosefile = ~/.log/vim/verbose.log
    set verbose     = 15
  else
    set verbose     = 0
    set verbosefile =
  endif
endfunction

function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

augroup BWCCreateDir
    autocmd!
		autocmd BufWritePre * if !isdirectory(expand("%:h")) | execute "silent! !mkdir -p " . shellescape(expand('%:h'), 1) | endif
augroup END

au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

let g:matchup_matchparen_offscreen = {'method': 'popup'}
