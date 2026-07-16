-- ============================================================
--  Elixir — Expert  (the new *official* language server; Next LS and the
--  old ElixirLS/Lexical efforts are being consolidated into it).
--
--  No Neovim plugin needed — Expert is driven by the built-in LSP client.
--
--  Install the `expert` binary (pick one):
--    * :MasonInstall expert        (if available in your Mason registry)
--    * download a release from https://github.com/elixir-lang/expert
--    * build from source: `just burrito-local`
--  Then make sure it's on PATH or in Mason's bin dir.
--  Invocation per the official install guide; update if Expert changes it:
--    https://github.com/elixir-lang/expert/blob/main/pages/installation.md
-- ============================================================

-- Prefer a Mason-installed binary, else fall back to `expert` on PATH.
local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/expert'
local exe = (vim.uv or vim.loop).fs_stat(mason_bin) and mason_bin or 'expert'

vim.lsp.config('expert', {
  cmd = { exe, '--stdio' },
  root_markers = { 'mix.exs', '.git' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
})

vim.lsp.enable 'expert'
