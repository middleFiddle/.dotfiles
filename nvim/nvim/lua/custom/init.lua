local autocmd = vim.api.nvim_create_autocmd

vim.o.expandtab = true
vim.opt.conceallevel = 1

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.fs,*.fsx,*.fsi",
  command = [[set filetype=fsharp]]
})

