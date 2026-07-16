-- ============================================================
--  Neovim config — kickstart-derived, built on native vim.pack
--  Migrated off NvChad. Requires Neovim 0.12+.
--
--  Layout:
--    init.lua            -> this file: bootstrap + module loader
--    lua/config/         -> options, keymaps, autocmds, pack plumbing
--    lua/plugins/        -> editor/UI/tooling plugins
--    lua/lang/           -> per-language tooling (LSP servers, REPLs, etc.)
--
--  To later swap vim.pack -> another manager, the only coupling point
--  is lua/config/pack.lua (the `add` helper) — modules call P.add{...}.
-- ============================================================

-- Speed up startup by caching compiled Lua modules.
vim.loader.enable()

-- Leader keys MUST be set before any plugin loads.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- You came from NvChad, so you have a Nerd Font configured.
vim.g.have_nerd_font = true

-- Foundation: options, keymaps, autocmds, then the vim.pack build hooks.
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.pack'

-- Load each feature module. We pcall so that a single broken module
-- (e.g. mid-edit) doesn't take down the whole config.
local function load(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.schedule(function()
      vim.notify(('Error loading %s:\n%s'):format(mod, err), vim.log.levels.ERROR)
    end)
  end
end

for _, mod in ipairs {
  -- Core editor experience
  'plugins.ui', -- colorscheme, statusline, bufferline, git signs, which-key
  'plugins.treesitter', -- syntax/indent/textobjects
  'plugins.telescope', -- fuzzy finder + LSP pickers
  'plugins.completion', -- blink.cmp + luasnip (load before lsp for capabilities)
  'plugins.lsp', -- mason + generic language servers
  'plugins.format', -- conform.nvim
  'plugins.editor', -- autopairs, autotag, guess-indent
  'plugins.explorer', -- neo-tree file explorer
  'plugins.multiplexer', -- the "tmux replacement": smart-splits + toggleterm + persistence

  -- Per-language tooling
  'lang.rust', -- rustaceanvim
  'lang.csharp', -- roslyn.nvim
  'lang.fsharp', -- Ionide-vim
  'lang.elixir', -- Expert
  'lang.lisp', -- conjure + racket
  'lang.lilypond', -- nvim-lilypond-suite
  'lang.markdown', -- obsidian + render-markdown
} do
  load(mod)
end

-- vim: ts=2 sts=2 sw=2 et
