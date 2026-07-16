-- ============================================================
--  Rust — rustaceanvim  (the maintained successor to the archived
--  simrat39/rust-tools.nvim). It auto-configures rust-analyzer; do NOT
--  also enable rust_analyzer via lspconfig/mason-lspconfig.
-- ============================================================

local P = require 'config.pack'

P.add { 'mrcjkb/rustaceanvim' }

-- Configured entirely via this global table (no setup() call).
vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        -- Use clippy for on-the-fly checking (you had rust.vim before).
        check = { command = 'clippy' },
        cargo = { allFeatures = true },
        inlayHints = { lifetimeElisionHints = { enable = 'always' } },
      },
    },
  },
}

-- Replicate your old `rustfmt_autosave` behaviour via LSP formatting.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rs',
  group = vim.api.nvim_create_augroup('rust-fmt-on-save', { clear = true }),
  callback = function()
    pcall(vim.lsp.buf.format, { timeout_ms = 2000 })
  end,
})
