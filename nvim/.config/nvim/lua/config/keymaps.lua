-- Keymaps (converted from vimrc)
local map = vim.keymap.set

-- ; to : (avoid shift for command mode)
map("n", ";", ":")
map("v", ";", ":")

-- jf to escape insert mode
map("i", "jf", "<esc>")

-- Create new vsplit and switch to it
map("n", "<leader>v", "<C-w>v")

-- Easy split navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Use sane regex when searching
map("n", "/", "/\\v")
map("v", "/", "/\\v")

-- Clear match highlighting
map("n", "<leader><space>", ":noh<cr>:call clearmatches()<cr>")

-- Quick buffer switching (like cmd-tab)
map("n", "<leader><leader>", "<c-^>")

-- Visual line nav (wrapped lines)
map("n", "j", "gj")
map("n", "k", "gk")

-- Toggle comments (vim-commentary)
map("n", "<leader>c", "<Plug>CommentaryLine")

-- NERDTree toggle
map("n", "`", ":NERDTreeToggle<CR>")
map("n", "~", ":NERDTreeFind<CR>")

-- FZF mappings
map("n", "<C-t>", ":Files<CR>")
map("n", "<leader>fp", ":Rg<Space>")
map("n", "<leader>fb", ":Buffers<CR>")
map("n", "<leader>fh", ":History<CR>")
