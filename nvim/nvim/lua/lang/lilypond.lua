-- ============================================================
--  LilyPond — nvim-lilypond-suite (nvls)
--  Provides syntax, compilation, audio preview and player for .ly/.ily.
--  Filetype detection for .ly/.ily is in lua/config/autocmds.lua.
-- ============================================================

local P = require 'config.pack'

P.add { 'martineausimon/nvim-lilypond-suite' }

require('nvls').setup {}
