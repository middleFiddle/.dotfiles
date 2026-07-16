-- ============================================================
--  Completion — blink.cmp + LuaSnip
--  (Loaded before plugins.lsp so its capabilities feed every server.)
-- ============================================================

local P = require 'config.pack'

P.add {
  { src = 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  'rafamadriz/friendly-snippets',
  { src = 'saghen/blink.cmp', version = vim.version.range '1.*' },
}

require('luasnip').setup {}
require('luasnip.loaders.from_vscode').lazy_load()

require('blink.cmp').setup {
  keymap = {
    -- 'default' = built-in-style: <C-y> accept, <C-space> menu/docs,
    -- <C-n>/<C-p> next/prev, <C-e> hide, <C-k> signature.
    preset = 'default',
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}
