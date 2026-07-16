-- ============================================================
--  Options  (`:help vim.o` / `:help option-list`)
-- ============================================================

local o = vim.o

-- Line numbers
o.number = true
o.relativenumber = true -- relative numbers make `5j`/`3k` jumps obvious

-- Mouse + UI
o.mouse = 'a'
o.showmode = false -- statusline already shows the mode
o.cursorline = true
o.signcolumn = 'yes'
o.scrolloff = 10
o.confirm = true -- ask to save instead of erroring on :q with changes

-- Indentation (guess-indent.nvim adjusts per file; these are the defaults)
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.smartindent = true
o.breakindent = true

-- Wrapping (you had this on in NvChad)
o.wrap = true
o.linebreak = true

-- Markdown / prose: conceal markup
o.conceallevel = 1

-- Search
o.ignorecase = true
o.smartcase = true
o.inccommand = 'split' -- live preview of :substitute

-- Splits open where you'd expect
o.splitright = true
o.splitbelow = true

-- Persistent undo, faster updates
o.undofile = true
o.updatetime = 250
o.timeoutlen = 300

-- Sync with system clipboard (scheduled to avoid slowing startup)
vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)

-- Whitespace rendering
o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Diagnostics presentation
vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = { source = 'if_many', spacing = 2 },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
}
