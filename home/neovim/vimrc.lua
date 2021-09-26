local o = vim.opt

o.cursorline     = true -- enable cursorline
o.cursorcolumn   = true
o.ruler          = true
o.number         = true
o.relativenumber = true
o.mouse          = "a"

o.undofile      = true
o.backup        = false
o.expandtab     = true
o.autowrite     = true
o.hidden        = true
o.hlsearch      = true
o.ignorecase    = true
o.smartcase     = true
o.equalalways   = true
o.autoindent    = true
o.smartindent   = true
o.smarttab      = true
o.splitbelow    = true
o.splitright    = true
o.startofline   = false
o.swapfile      = false
o.termguicolors = true
o.modelines     = 0
o.visualbell    = true
o.cmdheight     = 2
o.updatetime    = 300

o.virtualedit   = "all"
o.wrap = true
o.whichwrap = o.whichwrap + "<,>,[,],h,l"

o.completeopt   = {
  "menu",
  "menuone",
  "noselect",
  "noinsert",
}

o.encoding      = "UTF-8"
o.shortmess     = "csa"
o.signcolumn    = "yes"

o.laststatus     = 2 -- always enable statusline
o.pumheight      = 10 -- limit completion items
o.re             = 0 -- set regexp engine to auto
o.scrolloff      = 2 -- make scrolling better
o.sidescroll     = 2 -- make scrolling better
o.shiftwidth     = 2 -- set indentation width
o.sidescrolloff  = 15 -- make scrolling better
o.tabstop        = 2 -- tabsize
o.timeoutlen     = 400 -- faster timeout wait time
o.updatetime     = 1000 -- set faster update time
o.joinspaces     = false

-- stolen from tjdevries
o.formatoptions = o.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore


require("lualine").setup {
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
        },
        'coc#status'
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
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 40,
      },
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fugitive'}
}

require("bufferline").setup {
  diagnostics = 'coc'
}

require("package-info").setup {
  colors = {
    up_to_date = "#3C4048",
    outdated = "#d19a66",
  },
  autostart = true
}

require("which-key").setup {
  triggers = "auto",
}

local wk = require("which-key")

wk.register({
  ["["] = { "<plug>(coc-diagnostic-prev)", "Go to previous diagnostic" },
  ["]"] = { "<plug>(coc-diagnostic-next)", "Go to next diagnostic" },
}, { mode = "n", silent = true });

wk.register({
  n = {
    name = "package-info",
    s = { "<cmd>lua require('package-info').show()<cr>", "Show package info" },
    d = { "<cmd>lua require('package-info').delete()<cr>", "Delete package" },
    p = { "<cmd>lua require('package-info').change_version()<cr>", "Change package version" },
  },
}, { mode = "n", prefix = "<leader>", silent = true })

wk.register({
  ["<space>"] = { "<cmd>noh<cr>", "Clean search" },
  b = { "<cmd>bw<cr>", "Wipeout buffer" },
  s = { "<cmd>%s/\\<<C-r><C-w>\\>/" },
}, { mode = "n", prefix = "<leader>", silent = true })

wk.register({
  l = {
    name = "Language server",
    a = { "<cmd>CocAction<cr>", "Show action" },
    c = { "<cmd>CocCommand<cr>", "Show command" },
    D = { "<cmd>CocDiagnostics<cr>", "Show diagnostics" },
    E = { "<cmd>CocList extensions<cr>", "Show extensions" },
    l = { "<cmd>CocList location<cr>", "Location list" },
    s = { "<cmd>CocList services<cr>", "Services" },
    d = { "<plug>(coc-definition)", "Go to definition" },
    y = { "<plug>(coc-type-definition)", "Go to type definition" },
    i = { "<plug>(coc-implementation)", "Go to implementation" },
    r = { "<plug>(coc-rename)", "Rename" },
    R = { "<plug>(coc-references)", "Show references" },
    ca = { "<plug>(coc-codeaction)", "Execute codeaction" },
    f = { "<plug>(coc-format)", "Format" },
    h = { "<cmd>call CocAction('doHover')<cr>", "Show hover info" },
  },
}, { mode = "n", prefix = "<leader>", silent = true })

require('nvim-treesitter.configs').setup {
  ensure_installed = { },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.typescript.used_by = {"javascript", "javascriptreact"}
