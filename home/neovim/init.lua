local o = vim.opt

o.cursorline = true -- enable cursorline
o.cursorcolumn = true
o.ruler = true
o.number = true
o.relativenumber = true
o.mouse = "a"

o.undofile = true
o.backup = false
o.expandtab = true
o.autowrite = true
o.hidden = true
o.hlsearch = true
o.ignorecase = true
o.smartcase = true
o.equalalways = true
o.autoindent = true
o.smartindent = true
o.smarttab = true
o.splitbelow = true
o.splitright = true
o.startofline = false
o.swapfile = false
o.termguicolors = true
o.modelines = 0
o.visualbell = true
o.cmdheight = 2
o.updatetime = 300

o.virtualedit = "all"
o.wrap = true
o.whichwrap = o.whichwrap + "<,>,[,],h,l"

o.completeopt = {
  "menu",
  "menuone",
  "noselect",
  "noinsert",
}

o.encoding = "UTF-8"
o.shortmess = "aoOtTIcF"
o.signcolumn = "yes"

o.laststatus = 2 -- always enable statusline
o.pumheight = 10 -- limit completion items
o.re = 0 -- set regexp engine to auto
o.scrolloff = 2 -- make scrolling better
o.sidescroll = 2 -- make scrolling better
o.shiftwidth = 2 -- set indentation width
o.sidescrolloff = 15 -- make scrolling better
o.tabstop = 2 -- tabsize
o.timeoutlen = 400 -- faster timeout wait time
o.updatetime = 1000 -- set faster update time
o.joinspaces = false

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

local cmp = require("cmp")
local gps = require("nvim-gps")
local lspconfig = require("lspconfig")
local lspstatus = require("lsp-status")
local lspkind = require("lspkind")
local notify = require("notify")
local null_ls = require("null-ls")
local telescope = require("telescope")
local nb = null_ls.builtins

local bufferline = require("bufferline")
local lualine = require("lualine")
local ts_configs = require("nvim-treesitter.configs")
local ts_parsers = require("nvim-treesitter.parsers")
local package_info = require("package-info")
local wk = require("which-key")

local capabilities = vim.tbl_extend(
  "keep",
  require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  lspstatus.capabilities
)

require("nvim-lightbulb")

gps.setup()

lspstatus.register_progress()
local function lsp_status()
  return require("lsp-status").status()
end

lspstatus.config({
  diagnostics = false,
  current_function = false,
  status_symbol = "⏻",
  select_symbol = function(cursor_pos, symbol)
    if symbol.valueRange then
      local value_range = {
        ["start"] = {
          character = 0,
          line = vim.fn.byte2line(symbol.valueRange[1]),
        },
        ["end"] = {
          character = 0,
          line = vim.fn.byte2line(symbol.valueRange[2]),
        },
      }

      return require("lsp-status.util").in_range(cursor_pos, value_range)
    end
  end,
})

bufferline.setup({
  diagnostics = "nvim_lsp",
})

package_info.setup({
  colors = {
    up_to_date = "#3C4048",
    outdated = "#d19a66",
  },
  autostart = true,
})

wk.setup()

lspkind.init()

notify.setup()

vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local function on_attach(client, buf)
  lspstatus.on_attach(client)

  wk.register({
    l = {
      name = "Language server",
      d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      a = { "<cmd>CodeActionMenu<cr>", "Code action" },
      h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover info" },
      s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
      f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format document" },
    },
  }, {
    mode = "n",
    prefix = "<leader>",
    silent = true,
    buffer = buf,
  })

  wk.register({
    ["["] = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Previous diagnostic" },
    ["]"] = { "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "Next diagnostic" },
  }, {
    mode = "n",
    silent = true,
    buffer = buf,
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

require("gitsigns").setup()

require("trouble").setup()

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "╲", right = "╱" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = {
      {
        "mode",
        separator = { left = "" },
        padding = { left = 1, right = 2 },
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    },
    lualine_b = {
      "branch",
      "diff",
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        shorting_target = 40,
      },
      { "diagnostics", sources = { "nvim_lsp" } },
      lsp_status,
      { gps.get_location, cond = gps.is_available },
      package_info.get_status,
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = {
      {
        "location",
        separator = { right = "" },
        padding = { left = 2, right = 1 },
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
        shorting_target = 40,
      },
    },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "fugitive" },
})

wk.register({
  n = {
    name = "package-info",
    s = { "<cmd>lua require('package-info').show()<cr>", "Show package info" },
    d = { "<cmd>lua require('package-info').delete()<cr>", "Delete package" },
    p = { "<cmd>lua require('package-info').change_version()<cr>", "Change package version" },
    i = { "<cmd>lua require('package-info').install()<cr>", "Install package" },
    r = { "<cmd>lua require('package-info').reinstall()<cr>", "Reinstall package" },
  },
}, {
  mode = "n",
  prefix = "<leader>",
  silent = true,
})

wk.register({
  h = {
    name = "git",
    s = { "<cmd>lua require'gitsigns'.stage_hunk()<cr>", "Stage hunk" },
    u = { "<cmd>lua require'gitsigns'.undo_stage_hunk()<cr>", "Undo stage hunk" },
    r = { "<cmd>lua require'gitsigns'.reset_hunk()<cr>", "Reset hunk" },
    R = { "<cmd>lua require'gitsigns'.reset_buffer()<cr>", "Reset buffer" },
    p = { "<cmd>lua require'gitsigns'.preview_hunk()<cr>", "Preview hunk" },
    b = { "<cmd>lua require'gitsigns'.blame_line(true)<cr>", "Blame line" },
    S = { "<cmd>lua require'gitsigns'.stage_buffer()<cr>", "Stage buffer" },
    U = { "<cmd>lua require'gitsigns'.reset_buffer_index()<cr>", "Reset buffer index" },
    B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle blame" },
  },
}, {
  mode = "n",
  prefix = "<leader>",
  silent = true,
})

wk.register({
  ["<space>"] = { "<cmd>noh<cr>", "Clean search" },
  b = { "<cmd>bw<cr>", "Wipeout buffer" },
}, {
  mode = "n",
  prefix = "<leader>",
  silent = true,
})

telescope.setup()
telescope.load_extension("fzf")

local function project_files(opts)
  local options = opts or {}
  local git = pcall(require("telescope.builtin").git_files, options)
  if git then
    return require("telescope.builtin").git_files(options)
  else
    return require("telescope.builtin").find_files(options)
  end
end

wk.register({
  ["<C-p>"] = { project_files, "Find files" },
  ["<C-t>"] = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Show diagnostics" },
}, {
  mode = "n",
  noremap = true,
  silent = true,
})

ts_configs.setup({
  ensure_installed = {},
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
})

local parser_config = ts_parsers.get_parser_configs()
parser_config.typescript.used_by = { "javascript", "javascriptreact" }

vim.notify = notify

if vim.lsp.setup then
  vim.lsp.setup({
    floating_preview = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } },
    diagnostics = {
      signs = { error = " ", warning = " ", hint = " ", information = " " },
      display = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
      },
    },
    completion = {
      kind = {
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = "了 ",
        EnumMember = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = "ﰮ ",
        Keyword = " ",
        Method = "ƒ ",
        Module = " ",
        Property = " ",
        Snippet = "﬌ ",
        Struct = " ",
        Text = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
      },
    },
  })
else
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    severity_sort = true,
    virtual_text = {
      prefix = "▎",
      spacing = 2,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
  })

  local signs = {
    Error = " ",
    Warn = " ",
    Warning = " ",
    Hint = " ",
    Information = " ",
    Info = " ",
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    local hl2 = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl2, { text = icon, texthl = hl2, numhl = "" })
  end
end

require("lsp-colors").setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981",
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
  cmd = { "@sumneko_lua_language_server@/bin/lua-language-server" },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },

  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.flow.setup({
  cmd = { "@flow@/bin/flow", "lsp", "--from", "nvim-lsp" },
  flags = {
    debounce_text_changes = 150,
  },

  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.hls.setup({
  cmd = { "@haskell_language_server_wrapper@/bin/haskell-language-server-wrapper", "--lsp" },

  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.tsserver.setup({
  cmd = { "@typescript_language_server@/bin/typescript-language-server", "--stdio" },
  root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json"),

  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.rnix.setup({
  cmd = { "@rnix_lsp@/bin/rnix-lsp" },

  capabilities = capabilities,
  on_attach = on_attach,
})

require("rust-tools").setup({
  server = {
    cmd = { "@rust_analyzer@/bin/rust-analyzer" },

    capabilities = capabilities,
    on_attach = on_attach,
  },
})

local eslint_linter = {
  command = "@eslint_d@/bin/eslint_d",
  rootPatterns = { "package.json" },
  debounce = 50,
  args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json", "--no-color" },
  sourceName = "eslint",
  parseJson = {
    errorsRoot = "[0].messages",
    line = "line",
    column = "column",
    endLine = "endLine",
    endColumn = "endColumn",
    message = "[eslint] ${message} [${ruleId}]",
    security = "severity",
  },
  securities = {
    [2] = "error",
    [1] = "warning",
  },
}

local eslint_formatter = {
  command = "@eslint_d@/bin/eslint_d",
  debounce = 50,
  args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "%filepath" },
  isStdout = true,
  rootPatterns = { ".eslintrc.js", ".eslintrc.json" },
}

lspconfig.diagnosticls.setup({
  cmd = { "@diagnosticls@/bin/diagnostic-languageserver", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = lspconfig.util.root_pattern("package.json", "jsconfig.json"),
  init_options = {
    filetypes = {
      javascript = "eslint",
      javascriptreact = "eslint",
      typescript = "eslint",
      typescriptreact = "eslint",
    },
    formatFiletypes = {
      javascript = "eslint",
      javascriptreact = "eslint",
    },
    linters = {
      eslint = eslint_linter,
    },
    formatters = {
      eslint = eslint_formatter,
    },
  },
  on_init = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.code_action = true
    client.resolved_capabilities.execute_command = true

    os.execute("@eslint_d@/bin/eslint_d restart")
  end,

  capabilities = capabilities,
  on_attach = on_attach,
})

null_ls.config({
  diagnostics_format = "[#{c}] #{m} (#{s})",
  sources = {
    nb.diagnostics.shellcheck.with({ command = "@shellcheck@/bin/shellcheck" }),
    nb.formatting.stylua.with({
      command = "@stylua@/bin/stylua",
      extra_args = { "--config-path", vim.fn.expand("~/.config/stylua.toml") },
    }),
    nb.formatting.prettier.with({
      command = "@prettier@/bin/prettier",
      filetypes = { "vue", "svelte", "css", "scss", "html", "json", "yaml", "markdown" },
    }),
  },
})

lspconfig["null-ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.api.nvim_exec(
  [[
    hi DiagnosticUnderlineWarn gui=undercurl guisp=#e0af68
    hi DiagnosticUnderlineError gui=undercurl guisp=#db4b4b
    hi DiagnosticUnderlineHint gui=undercurl guisp=#1abc9c
    hi DiagnosticUnderlineInfo gui=undercurl guisp=#0db9d7
  ]],
  false
)

vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({ focusable=false })]])
vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
