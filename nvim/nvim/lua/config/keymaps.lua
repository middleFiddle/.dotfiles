-- ============================================================
--  Core keymaps  (`:help vim.keymap.set()`)
--
--  Plugin-specific maps live next to their plugin (telescope, neo-tree,
--  smart-splits, toggleterm, LSP, etc.). This file holds the basics.
--
--  NOTE: <C-h/j/k/l> window navigation is intentionally NOT set here —
--  smart-splits owns those in lua/plugins/multiplexer.lua so they also
--  hop into tmux panes when tmux is present.
-- ============================================================

local map = vim.keymap.set

-- Clear search highlight on <Esc>
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Save (muscle memory from NvChad)
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR><Esc>', { desc = 'Save file' })

-- Diagnostics
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode more easily
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Buffers (bufferline provides the visible tabs; these cycle/close them)
map('n', '<Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<leader>x', '<cmd>bdelete<CR>', { desc = 'Close buffer' })

-- Keep selection when re-indenting in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Move selected lines up/down
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
