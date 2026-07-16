-- ============================================================
--  Telescope — fuzzy finder for files, grep, LSP symbols, etc.
--  Keymaps lean on NvChad muscle memory (<leader>ff, <leader>fw)
--  plus the kickstart <leader>s* "search" family.
-- ============================================================

local P = require 'config.pack'

local plugins = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
}
if vim.fn.executable 'make' == 1 then
  table.insert(plugins, 'nvim-telescope/telescope-fzf-native.nvim')
end
P.add(plugins)

require('telescope').setup {
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
local map = vim.keymap.set

-- NvChad-style finders
map('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
map('n', '<leader>fw', builtin.live_grep, { desc = '[F]ind [W]ord (live grep)' })
map('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
map('n', '<leader>fo', builtin.oldfiles, { desc = '[F]ind [O]ld files' })

-- kickstart "search" family
map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })

map('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { previewer = false })
end, { desc = '[/] Fuzzily search in current buffer' })

map('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim config' })

-- LSP-powered pickers, attached per-buffer when a server connects.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local b = event.buf
    local function m(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = b, desc = 'LSP: ' .. desc })
    end
    m('grr', builtin.lsp_references, '[G]oto [R]eferences')
    m('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
    m('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
    m('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
    m('gO', builtin.lsp_document_symbols, 'Document Symbols')
    m('gW', builtin.lsp_dynamic_workspace_symbols, 'Workspace Symbols')
  end,
})
