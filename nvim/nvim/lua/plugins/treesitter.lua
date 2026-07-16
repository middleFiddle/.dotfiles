-- ============================================================
--  Treesitter — highlight, indent, incremental selection
--
--  Using the stable `master` branch (classic `.configs` API) for
--  reliability across this many languages. Parsers auto-install on
--  first open of a filetype (auto_install = true).
-- ============================================================

local P = require 'config.pack'

P.add {
  { src = 'nvim-treesitter/nvim-treesitter', version = 'master' },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    -- editor essentials
    'lua',
    'luadoc',
    'vim',
    'vimdoc',
    'query',
    'bash',
    'json',
    'jsonc',
    'yaml',
    'toml',
    'markdown',
    'markdown_inline',
    'diff',
    'gitcommit',
    -- your languages
    'c_sharp',
    'fsharp',
    'rust',
    'elixir',
    'eex',
    'heex',
    'ocaml',
    'ocaml_interface',
    'javascript',
    'typescript',
    'tsx',
    'css',
    'html',
    'scheme',
  },
  auto_install = true,
  highlight = {
    enable = true,
    -- LilyPond is handled by nvim-lilypond-suite, not a TS parser.
    disable = { 'lilypond' },
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      node_decremental = '<bs>',
    },
  },
}
