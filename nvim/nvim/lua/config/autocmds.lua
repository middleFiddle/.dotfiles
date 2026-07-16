-- ============================================================
--  Autocommands & filetypes  (`:help lua-guide-autocommands`)
-- ============================================================

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Restore cursor to last position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore last cursor position',
  group = vim.api.nvim_create_augroup('last-cursor', { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Filetype detection that Neovim doesn't ship by default.
-- (Replaces the BufRead autocmds from your NvChad config.)
vim.filetype.add {
  extension = {
    fs = 'fsharp',
    fsx = 'fsharp',
    fsi = 'fsharp',
    ly = 'lilypond',
    ily = 'lilypond',
  },
}
