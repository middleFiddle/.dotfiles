-- ============================================================
--  LSP core
--
--  - Mason installs servers/tools (incl. the Crashdummyy registry for roslyn)
--  - blink.cmp capabilities are applied globally via vim.lsp.config('*')
--  - LspAttach sets the buffer-local keymaps (rename, code action, hover,
--    inlay hints, document highlight). Telescope adds the picker maps.
--  - "Plain" servers are configured here. Servers that need a dedicated
--    plugin (rust_analyzer, roslyn, ionide/fsautocomplete, expert) live in
--    their lua/lang/*.lua module instead.
-- ============================================================

local P = require 'config.pack'

P.add {
  'neovim/nvim-lspconfig',
  'mason-org/mason.nvim',
  'mason-org/mason-lspconfig.nvim',
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  'j-hui/fidget.nvim',
}

require('fidget').setup {}

require('mason').setup {
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry', -- provides `roslyn` (and `rzls` for Razor)
  },
}

-- Apply completion capabilities to every server, once and globally.
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- [[ Per-buffer LSP keymaps + behaviours ]]
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, fn, desc, mode)
      vim.keymap.set(mode or 'n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('K', vim.lsp.buf.hover, 'Hover documentation')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Highlight references of the symbol under the cursor.
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local hl = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = hl,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = hl,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(e2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e2.buf }
        end,
      })
    end

    -- Toggle inlay hints if the server supports them.
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- ============================================================
--  Generic ("plain") servers
-- ============================================================

-- Helper: only attach in a project rooted by one of `markers`, and (for ts_ls)
-- bail out entirely if it's actually a Deno project.
local function root(markers, opts)
  opts = opts or {}
  return function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if opts.not_if_deno then
      local deno = vim.fs.root(fname, { 'deno.json', 'deno.jsonc' })
      if deno then
        return -- let denols handle this buffer instead
      end
    end
    local dir = vim.fs.root(fname, markers)
    if dir then
      on_dir(dir)
    end
  end
end

---@type table<string, vim.lsp.Config>
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        format = { enable = false }, -- stylua handles formatting
      },
    },
  },

  -- Web: TypeScript/JavaScript (skips Deno projects), Deno, Tailwind, ESLint, Astro
  ts_ls = {
    root_dir = root({ 'package.json', 'tsconfig.json', 'jsconfig.json' }, { not_if_deno = true }),
  },
  denols = {
    root_dir = root { 'deno.json', 'deno.jsonc' },
  },
  tailwindcss = {},
  eslint = {},
  astro = {},

  -- OCaml
  ocamllsp = {},

  -- Racket / Scheme (install the server with: raco pkg install racket-langserver)
  racket_langserver = {
    filetypes = { 'racket', 'scheme' },
  },
}

for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

-- Install the servers above (that live in Mason) plus formatters/tools.
-- mason-lspconfig translates lspconfig names -> Mason package names.
require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'ts_ls', 'denols', 'tailwindcss', 'eslint', 'astro', 'ocamllsp' },
  automatic_enable = false, -- we enable explicitly above (keeps deno/ts_ls from double-attaching)
}
require('mason-tool-installer').setup {
  ensure_installed = {
    'stylua', -- Lua formatter
    'prettierd', -- JS/TS/CSS/HTML/JSON/MD formatter
    'ocamlformat', -- OCaml formatter
    'rust-analyzer', -- used by rustaceanvim (lang/rust.lua)
  },
}
