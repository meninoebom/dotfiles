-- Options (converted from vimrc)
local opt = vim.opt

-- Line numbers
opt.number = true

-- Colors
opt.background = "dark"
opt.termguicolors = true

-- Tabs and spaces
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true      -- use spaces instead of tabs
opt.smarttab = true       -- tab key insert 'tab stops', bksp deletes tabs
opt.shiftround = true     -- tab / shifting moves to closest tabstop
opt.autoindent = true     -- match indents on new lines
opt.smartindent = true    -- intelligently dedent/indent new lines

-- No backups (we have VCS)
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Buffers
opt.hidden = true         -- allow buffers with unsaved changes
opt.autoread = true       -- reload files changed on disk

-- Search
opt.ignorecase = true     -- case insensitive search
opt.smartcase = true      -- case-sensitive if uppercase letters
opt.incsearch = true      -- live incremental searching
opt.hlsearch = true       -- highlight matches
opt.gdefault = true       -- use 'g' flag by default

-- Visual block mode
opt.virtualedit = "block"

-- Status line
opt.laststatus = 2
opt.statusline = "%f"

-- Misc
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")
