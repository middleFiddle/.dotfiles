-- ============================================================
--  Markdown — in-buffer rendering only
--
--  Notes/PKM live in Org (Emacs), not here. This module just makes plain
--  .md files pleasant to read in Neovim; there is no Obsidian/vault logic.
-- ============================================================

local P = require 'config.pack'

P.add {
  'MeanderingProgrammer/render-markdown.nvim',
}

require('render-markdown').setup {
  latex = { enabled = false },
}
