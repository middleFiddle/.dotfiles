-- ============================================================
--  UI: colorscheme, icons, statusline, bufferline, git signs,
--      which-key, todo-comments, mini textobjects/surround
-- ============================================================

local P = require 'config.pack'

P.add {
  'catppuccin/nvim',
  'nvim-tree/nvim-web-devicons',
  'nvim-lua/plenary.nvim', -- shared dependency (telescope, neo-tree, etc.)
  'nvim-lualine/lualine.nvim',
  'akinsho/bufferline.nvim',
  'lewis6991/gitsigns.nvim',
  'folke/which-key.nvim',
  'folke/todo-comments.nvim',
  'nvim-mini/mini.nvim',
}

-- [[ Colorscheme ]] — catppuccin mocha, matching your NvChad theme
require('catppuccin').setup {
  flavour = 'mocha',
  integrations = {
    blink_cmp = true,
    gitsigns = true,
    treesitter = true,
    telescope = true,
    which_key = true,
    mason = true,
    native_lsp = { enabled = true },
  },
}
vim.cmd.colorscheme 'catppuccin'

require('nvim-web-devicons').setup {}

-- [[ Statusline ]]
require('lualine').setup {
  options = {
    theme = 'catppuccin',
    icons_enabled = vim.g.have_nerd_font,
    section_separators = '',
    component_separators = '|',
    globalstatus = true,
  },
}

-- [[ Bufferline ]] — tmux-window-like tabs for open buffers (<Tab>/<S-Tab> to cycle)
require('bufferline').setup {
  options = {
    diagnostics = 'nvim_lsp',
    separator_style = 'thin',
    show_buffer_close_icons = false,
    offsets = {
      { filetype = 'neo-tree', text = 'Explorer', highlight = 'Directory', separator = true },
    },
  },
}

-- [[ Git signs in the gutter ]]
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = require 'gitsigns'
    local function m(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end
    m('n', ']c', function() gs.nav_hunk 'next' end, 'Next git hunk')
    m('n', '[c', function() gs.nav_hunk 'prev' end, 'Prev git hunk')
    m('n', '<leader>hs', gs.stage_hunk, 'Git [H]unk [S]tage')
    m('n', '<leader>hr', gs.reset_hunk, 'Git [H]unk [R]eset')
    m('n', '<leader>hp', gs.preview_hunk, 'Git [H]unk [P]review')
    m('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Git [H]unk [B]lame line')
  end,
}

-- [[ todo-comments ]] highlight TODO/FIXME/etc.
require('todo-comments').setup { signs = false }

-- [[ which-key ]] — discoverable keybinds + group labels
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]erminal/[T]oggle' },
    { '<leader>S', group = '[S]ession' },
    { '<leader>c', group = '[C]ode' },
    { '<leader>r', group = '[R]ename' },
    { 'gr', group = 'LSP' },
  },
}

-- [[ mini.nvim modules ]]
-- Better Around/Inside textobjects:  va)  yi'  ci"  (and aa/ii for "next")
require('mini.ai').setup {
  mappings = { around_next = 'aa', inside_next = 'ii' },
  n_lines = 500,
}
-- Surround:  saiw)  sd'  sr)'
require('mini.surround').setup()
