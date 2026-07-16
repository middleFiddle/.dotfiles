-- ============================================================
--  C# — roslyn.nvim  (the open-source Roslyn server that replaced
--  OmniSharp; the same server VS Code's C# extension uses).
--
--  Requires:  Neovim 0.12+ (have it), .NET SDK 10+ on PATH, and the
--  `roslyn` server from the Crashdummyy Mason registry:  :MasonInstall roslyn
--  (Razor support also wants `rzls`.)
-- ============================================================

local P = require 'config.pack'

P.add { 'seblyng/roslyn.nvim' }

-- Server settings (inlay hints + code lens). Inlay hints still need to be
-- *enabled* per buffer — see the LspAttach autocmd below.
vim.lsp.config('roslyn', {
  settings = {
    ['csharp|inlay_hints'] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      dotnet_enable_inlay_hints_for_parameters = true,
    },
    ['csharp|code_lens'] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

require('roslyn').setup {}

-- Turn inlay hints on automatically for C# buffers (matches your old config).
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('roslyn-inlay-hints', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'roslyn' then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
