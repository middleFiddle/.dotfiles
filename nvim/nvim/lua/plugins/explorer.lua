-- ============================================================
--  File explorer — neo-tree
--  <C-n> toggles (NvChad muscle memory), <leader>e focuses/toggles.
-- ============================================================

local P = require 'config.pack'

P.add {
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  'nvim-tree/nvim-web-devicons',
  'nvim-neo-tree/neo-tree.nvim',
}

require('neo-tree').setup {
  close_if_last_window = true,
  filesystem = {
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = { hide_dotfiles = false, hide_gitignored = true },
  },
  window = {
    width = 32,
    mappings = {
      ['<space>'] = 'none', -- don't steal the leader key
    },
  },
}

vim.keymap.set('n', '<C-n>', '<cmd>Neotree toggle<CR>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>e', '<cmd>Neotree focus<CR>', { desc = 'Focus file [E]xplorer' })
