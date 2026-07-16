-- ============================================================
--  Lisps — Conjure (interactive REPL eval) for Racket/Scheme/etc.
--  The racket_langserver LSP itself is configured in plugins/lsp.lua.
--
--  Racket REPL needs the `racket` binary on PATH.
-- ============================================================

local P = require 'config.pack'

-- Set client options before Conjure loads (it reads these on first eval).
vim.g['conjure#filetype#racket'] = 'conjure.client.racket.stdio'
vim.g['conjure#client#racket#stdio#command'] = 'racket --interactive'

P.add { 'Olical/conjure' }
