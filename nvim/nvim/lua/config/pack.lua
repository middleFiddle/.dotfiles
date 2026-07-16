-- ============================================================
--  vim.pack plumbing
--
--  `vim.pack` is Neovim's built-in plugin manager (0.12+).
--  See `:help vim.pack` and https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
--
--  This module exposes a thin `add` helper so feature modules can write
--    P.add { 'owner/repo', { src = 'owner/repo2', version = '...' } }
--  instead of spelling out full GitHub URLs each time. It is the single
--  point of coupling to vim.pack, making a future manager swap mechanical.
-- ============================================================

local M = {}

---Expand 'owner/repo' to a full GitHub URL.
---@param repo string
---@return string
local function gh(repo)
  return 'https://github.com/' .. repo
end
M.gh = gh

---Add one or more plugins. Each item is either a short 'owner/repo' string
---or a vim.pack.Spec table whose `src` is a short 'owner/repo'.
---@param items (string|table)[]
---@param opts? table forwarded to vim.pack.add (e.g. { load = false })
function M.add(items, opts)
  local specs = {}
  for _, item in ipairs(items) do
    if type(item) == 'string' then
      specs[#specs + 1] = gh(item)
    else
      item.src = gh(item.src)
      specs[#specs + 1] = item
    end
  end
  vim.pack.add(specs, opts)
end

-- Build steps that must run after certain plugins are installed/updated.
-- See `:help vim.pack-events`.
local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local output = (result.stderr ~= '' and result.stderr) or result.stdout
    if not output or output == '' then
      output = 'No output from build command.'
    end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      run_build(name, { 'make' }, ev.data.path)
    elseif name == 'LuaSnip' then
      if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
      end
    elseif name == 'nvim-treesitter' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      pcall(vim.cmd.TSUpdate)
    end
  end,
})

return M
