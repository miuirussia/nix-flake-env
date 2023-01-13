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

set nocompatible
set clipboard+=unnamed

" remap leader
" map leader key to space
let g:mapleader = ","
let g:maplocalleader = ","

lua << EOF
local o = vim.opt

o.whichwrap = o.whichwrap + "<,>,[,],h,l"
o.encoding = "UTF-8"
EOF
