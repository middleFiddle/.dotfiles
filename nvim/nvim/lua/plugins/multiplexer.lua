-- ============================================================
--  "tmux inside Neovim"
--
--  The features people actually use tmux for, locally:
--    * smart-splits  -> move/resize splits with <C-hjkl> (and hops into
--                       real tmux panes too, if you ever install tmux).
--                       This replaces your old vim-tmux-navigator.
--    * toggleterm    -> terminals as splits/floats, like tmux panes.
--    * persistence   -> save & restore your window/buffer layout per project,
--                       like reattaching a tmux session after a restart.
-- ============================================================

local P = require 'config.pack'

P.add {
  'mrjones2014/smart-splits.nvim',
  'akinsho/toggleterm.nvim',
  'folke/persistence.nvim',
}

-- ---------- smart-splits: navigation + resizing ----------
local ss = require 'smart-splits'
ss.setup {}

local map = vim.keymap.set
-- Move between splits (and tmux panes if present)
map('n', '<C-h>', ss.move_cursor_left, { desc = 'Move to left split' })
map('n', '<C-j>', ss.move_cursor_down, { desc = 'Move to lower split' })
map('n', '<C-k>', ss.move_cursor_up, { desc = 'Move to upper split' })
map('n', '<C-l>', ss.move_cursor_right, { desc = 'Move to right split' })
-- Resize splits with Alt + hjkl
map('n', '<A-h>', ss.resize_left, { desc = 'Resize split left' })
map('n', '<A-j>', ss.resize_down, { desc = 'Resize split down' })
map('n', '<A-k>', ss.resize_up, { desc = 'Resize split up' })
map('n', '<A-l>', ss.resize_right, { desc = 'Resize split right' })

-- ---------- toggleterm: terminals like tmux panes ----------
require('toggleterm').setup {
  open_mapping = [[<c-\>]], -- toggle a terminal with Ctrl-\
  direction = 'float',
  float_opts = { border = 'curved' },
}

map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Terminal (float)' })
map('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal size=15<CR>', { desc = 'Terminal (horizontal)' })
map('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<CR>', { desc = 'Terminal (vertical)' })

-- lazygit in a floating terminal (only wired up if lazygit is installed)
if vim.fn.executable 'lazygit' == 1 then
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new { cmd = 'lazygit', hidden = true, direction = 'float' }
  map('n', '<leader>tg', function()
    lazygit:toggle()
  end, { desc = 'Terminal: lazy[G]it' })
end

-- ---------- persistence: tmux-like session restore ----------
require('persistence').setup {}

map('n', '<leader>Ss', function()
  require('persistence').load()
end, { desc = '[S]ession: restore for cwd' })
map('n', '<leader>Sl', function()
  require('persistence').load { last = true }
end, { desc = '[S]ession: restore [L]ast' })
map('n', '<leader>Sd', function()
  require('persistence').stop()
end, { desc = "[S]ession: [D]on't save this one" })
