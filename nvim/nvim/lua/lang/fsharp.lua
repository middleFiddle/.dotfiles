-- ============================================================
--  F# — Ionide-vim
--
--  Modern Ionide ships its own `ionide` config for vim.lsp.config() and
--  enables it automatically — no nvim-lspconfig glue required.
--
--  Requires:  .NET SDK on PATH and FsAutoComplete:
--    dotnet tool install -g fsautocomplete
--  (or :MasonInstall fsautocomplete once a .NET SDK is available)
-- ============================================================

local P = require 'config.pack'

-- ft-guarded: Ionide registers the LSP config on load; the .fs/.fsx/.fsi
-- filetype detection lives in lua/config/autocmds.lua.
P.add { 'ionide/Ionide-vim' }

-- Show type tooltips on hover-hold for F# files.
vim.api.nvim_create_autocmd('CursorHold', {
  pattern = { '*.fs', '*.fsi', '*.fsx' },
  group = vim.api.nvim_create_augroup('fsharp-tooltip', { clear = true }),
  callback = function()
    pcall(vim.fn['fsharp#showTooltip'])
  end,
})
