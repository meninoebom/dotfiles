-- Autocommands (converted from vimrc)
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Strip trailing whitespace on save for JS/Perl files
local whitespace_group = augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = whitespace_group,
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.pl" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
