-- ============================================================
--  Editor niceties — autopairs, autotag, guess-indent
--  (Commenting is built in to Neovim 0.12: gcc / gc{motion} / gc in visual.)
-- ============================================================

local P = require 'config.pack'

P.add {
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',
  'NMAC427/guess-indent.nvim',
}

require('nvim-autopairs').setup {}

-- Auto-close/rename HTML/JSX tags (drives off treesitter).
require('nvim-ts-autotag').setup {}

-- Detect indentation per file and set the options to match.
require('guess-indent').setup {}
