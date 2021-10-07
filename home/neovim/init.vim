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

let g:edge_style = 'aura'
let g:edge_enable_italic = 1
colorscheme edge

" remap leader
" map leader key to space
let g:mapleader = ","
let g:maplocalleader = ","

" quicker access to commands
nnoremap ; :
nnoremap Q <nop>

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

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,**/node_modules/*,**/flow-typed/*

" jsx
let g:jsx_ext_required       = 0

" Tab for formatting
vnoremap <Tab> :'<,'>Tab /

let g:markdown_fenced_languages = ['typescript=javascript', 'flow=javascript.jsx']

let g:better_whitespace_enabled  = 1
let g:strip_whitespace_on_save   = 1

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
