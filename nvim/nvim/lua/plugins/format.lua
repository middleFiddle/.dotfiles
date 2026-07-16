-- ============================================================
--  Formatting — conform.nvim  (replaces your old none-ls/null-ls setup)
--
--  Format-on-save for web + lua + ocaml. Rust formatting is owned by
--  rustaceanvim (rustfmt on save); F# by Ionide; C# by Roslyn — so they
--  fall through to LSP formatting here.
-- ============================================================

local P = require 'config.pack'

P.add { 'stevearc/conform.nvim' }

local prettier = { 'prettierd', 'prettier', stop_after_first = true }

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Filetypes we autoformat on save.
    local enabled = {
      lua = true,
      javascript = true,
      javascriptreact = true,
      typescript = true,
      typescriptreact = true,
      astro = true,
      css = true,
      html = true,
      json = true,
      jsonc = true,
      yaml = true,
      markdown = true,
      ocaml = true,
    }
    if not enabled[vim.bo[bufnr].filetype] then
      return nil
    end
    return { timeout_ms = 1000, lsp_format = 'fallback' }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = prettier,
    javascriptreact = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    astro = prettier,
    css = prettier,
    html = prettier,
    json = prettier,
    jsonc = prettier,
    yaml = prettier,
    markdown = prettier,
    ocaml = { 'ocamlformat' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]or[m]at buffer' })
