-- ============================================================================
-- Brandon's Neovim  ·  single-file, modern, minimal.
--
-- Philosophy: one file you can read top to bottom. Native Vim keys, real LSP,
-- fast completion, fuzzy finding, project find/replace, and Claude Code.
-- Plugins are managed by lazy.nvim and pinned in lazy-lock.json (committed).
--
-- First launch installs everything automatically. Then run :Mason to see
-- language servers and :checkhealth if anything looks off.
-- ============================================================================

-- ── Core options ────────────────────────────────────────────────────────────
-- Leader must be set before plugins load. Space is the modern default.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true              -- absolute line numbers
opt.relativenumber = true      -- relative numbers for fast j/k motions
opt.mouse = "a"                -- mouse works (resize splits, etc.) without losing Vim
opt.clipboard = "unnamedplus"  -- yank/paste share the macOS system clipboard
opt.ignorecase = true          -- case-insensitive search...
opt.smartcase = true           -- ...unless the query has a capital letter
opt.undofile = true            -- persistent undo across sessions
opt.signcolumn = "yes"         -- reserve the gutter so text doesn't jump
opt.termguicolors = true       -- 24-bit color
opt.scrolloff = 8              -- keep 8 lines of context above/below the cursor
opt.expandtab = true           -- tabs insert spaces
opt.shiftwidth = 2             -- indent width
opt.tabstop = 2
opt.splitright = true          -- new vertical splits open to the right
opt.splitbelow = true          -- new horizontal splits open below
opt.inccommand = "split"       -- live preview of :substitute as you type it

-- A few quality-of-life keymaps (Vim itself already gives you the rest).
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })
-- Move focus between splits with Ctrl+h/j/k/l (no leader needed).
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

-- ── Bootstrap lazy.nvim (the plugin manager) ────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ─────────────────────────────────────────────────────────────────
require("lazy").setup({

  -- Colorscheme. Loaded first (priority) so nothing flashes unstyled.
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Treesitter: accurate syntax highlighting and structural text objects.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",  -- pin the stable API; the default branch is a WIP rewrite
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "json", "yaml", "toml", "markdown",
        "python", "javascript", "typescript", "tsx", "rust", "html", "css",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Telescope: fuzzy finder for files, live grep, symbols, everything.
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Grep in project" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })
    end,
  },

  -- Mason: installs language servers, formatters, linters into a private dir.
  { "williamboman/mason.nvim", opts = {} },

  -- LSP: the engine behind go-to-definition, rename, hover, diagnostics.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Which servers to auto-install and enable. Add more as you need them.
      local servers = { "lua_ls", "ts_ls", "pyright", "rust_analyzer" }
      require("mason-lspconfig").setup({ ensure_installed = servers })

      -- Tell each server what completion capabilities the client (blink) has.
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- LSP keymaps attach only to buffers that actually have a server running.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local b = { buffer = event.buf }
          map("n", "grn", vim.lsp.buf.rename, vim.tbl_extend("force", b, { desc = "LSP rename symbol" }))
          map("n", "gra", vim.lsp.buf.code_action, vim.tbl_extend("force", b, { desc = "LSP code action" }))
          map("n", "grd", vim.lsp.buf.definition, vim.tbl_extend("force", b, { desc = "Go to definition" }))
          map("n", "grr", require("telescope.builtin").lsp_references, vim.tbl_extend("force", b, { desc = "LSP references" }))
          map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", b, { desc = "Hover docs" }))
        end,
      })
    end,
  },

  -- blink.cmp: fast (Rust core) autocompletion. Ships a prebuilt binary.
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" },  -- Ctrl+n/p to cycle, Ctrl+y to accept
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- grug-far: project-wide find AND replace (the LSP rename above is symbol-only).
  {
    "MagicDuck/grug-far.nvim",
    opts = {},
    config = function(_, opts)
      require("grug-far").setup(opts)
      map("n", "<leader>sr", "<cmd>GrugFar<CR>", { desc = "Search & replace in project" })
    end,
  },

  -- Claude Code, native inside Neovim. Speaks the same protocol as the
  -- VS Code / Cursor extensions: send selections, at-mention buffers, review
  -- Claude's edits as native diffs.
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {},
    cmd = { "ClaudeCode", "ClaudeCodeSend", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny" },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude Code" },
      { "<leader>as", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "Accept Claude's diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "Reject Claude's diff" },
    },
  },

  -- which-key: pop-up cheatsheet. Pause after <leader> and it shows your maps.
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

}, {
  -- lazy.nvim UI/behavior options.
  checker = { enabled = false },  -- don't auto-check for plugin updates
  change_detection = { notify = false },
})
