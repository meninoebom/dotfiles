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
opt.cursorline = true          -- band under the cursor line: never hunt for your place
opt.linebreak = true           -- wrap long lines at words, not mid-word (prose, markdown)
opt.updatetime = 250           -- how long you must idle before CursorHold fires.
                               -- Vim ships 4000ms, which would make the :checktime
                               -- autocmd below take 4s to notice Claude's edits.
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

-- Neovim 0.11+ ships its own LSP maps under a `gr` prefix (grn/gra/grr/gri/grt).
-- We bind plain `gr` to "find references" below, and a prefix cannot coexist with
-- a mapping that IS that prefix: Vim would pause for `timeoutlen` after every `gr`
-- waiting to see if an `n` is coming. Dropping the defaults removes the pause.
-- pcall because these only exist on versions that define them.
for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt" }) do
  pcall(vim.keymap.del, "n", lhs)
end

-- Reload buffers when a file changes underneath us. `autoread` is what performs the
-- reload, but Vim only NOTICES the change when it runs `:checktime`, which it does
-- rarely on its own. These events make it check whenever you pause or refocus, so
-- files edited by Claude Code in another pane show up without a manual :e.
opt.autoread = true
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    -- Skip command-line windows and anything not backed by a real file, where
    -- :checktime is meaningless and errors.
    if vim.fn.getcmdwintype() == "" and vim.bo.buftype == "" then
      vim.cmd.checktime()
    end
  end,
})

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
  --
  -- Gruvbox Material, hard background: warm and low-blue (easier on the eyes over
  -- a long session than a cool blue-black), but with hard contrast so text still
  -- pops. Tuned below for one goal: maximum readability.
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"       -- darkest of hard/medium/soft
      vim.g.gruvbox_material_foreground = "material"   -- softest of the three fg palettes
      vim.g.gruvbox_material_ui_contrast = "high"      -- brighter line numbers, indent lines
      vim.g.gruvbox_material_disable_italic_comment = 1 -- italics render thin in terminals
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_better_performance = 1

      -- High-visibility overrides.
      --
      -- Every dark theme, this one included, paints selections with a color that
      -- sits a hair above the background: on the hard background its blue visual
      -- is #2e3b3b against a #1d2021 page, a ~4% luminance step. That is what
      -- reads as a "translucent" highlight you can't see. Theme authors tune these
      -- groups to be calm; calm and visible are in tension, and here visible wins.
      --
      -- So every "something is marked here" group is replaced with a solid,
      -- high-contrast block, and each gets a DIFFERENT color, so the color alone
      -- tells you which kind of mark you are looking at.
      --
      -- This is the one table to tune. Colors are from the Gruvbox palette, so
      -- anything you swap in from the theme will stay coherent.
      local function high_visibility()
        local hl = vim.api.nvim_set_hl

        -- Selection: steel-blue block, cream text. The foreground is forced on
        -- purpose. If only the background changed, a selected comment (the dimmest
        -- text on screen) would sit at ~2:1 contrast and turn to mush; forcing the
        -- text to cream keeps everything inside the selection legible at ~5:1.
        -- Blue is chosen because every syntax color in Gruvbox is warm, so a cool
        -- selection never gets confused for the code underneath it.
        hl(0, "Visual",    { bg = "#4a5f6f", fg = "#f2e5bc" })
        hl(0, "VisualNOS", { bg = "#4a5f6f", fg = "#f2e5bc" })

        -- Search: black on amber for every match, black on red for the match you
        -- are actually sitting on, black on orange while you are still typing.
        -- Three colors, three meanings, no squinting.
        hl(0, "Search",    { bg = "#d8a657", fg = "#1d2021", bold = true })
        hl(0, "CurSearch", { bg = "#ea6962", fg = "#1d2021", bold = true })
        hl(0, "IncSearch", { bg = "#e78a4e", fg = "#1d2021", bold = true })

        -- Completion menu reuses the selection's visual language deliberately:
        -- "the thing that is currently picked" should look the same everywhere.
        hl(0, "Pmenu",    { bg = "#282828", fg = "#d4be98" })
        hl(0, "PmenuSel", { bg = "#4a5f6f", fg = "#f2e5bc", bold = true })

        -- Cursor position stays quiet on purpose. It is on screen every second, so
        -- a loud band here is fatiguing rather than helpful. The line number does
        -- the shouting instead.
        hl(0, "CursorLine",   { bg = "#32302f" })
        hl(0, "CursorLineNr", { fg = "#d8a657", bold = true })
        hl(0, "MatchParen",   { bg = "#5a524c", fg = "#e78a4e", bold = true })

        -- Comments ship at #928374, which lands just under the WCAG AA contrast
        -- floor (~4.4:1) against this background. #a89984 clears it (~5.9:1).
        hl(0, "Comment", { fg = "#a89984" })
      end

      -- Registered before the colorscheme is applied, so it runs on load and again
      -- on any later :colorscheme call rather than being wiped by one.
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox-material",
        callback = high_visibility,
      })
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  -- Treesitter: accurate syntax highlighting and indentation.
  --
  -- This is the `main` branch. The old `master` branch is frozen and, in its own
  -- words, "Neovim 0.12 is not supported" -- running it on 0.12 is what threw the
  -- `attempt to call method 'range' (a nil value)` crash. `main` is a full,
  -- deliberately incompatible rewrite, so this block looks nothing like the old one.
  --
  -- The big conceptual change: `main` only INSTALLS parsers and ships queries. It
  -- turns nothing on. Highlighting and indentation are Neovim's own features now,
  -- and something has to start them per buffer -- that is the autocommand below.
  --
  -- Needs the tree-sitter CLI (`brew install tree-sitter-cli`) and a C compiler.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,     -- `main` explicitly does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      -- Installed on first launch; a no-op once they are present. Async, so the
      -- very first start of a given filetype may be unhighlighted until it finishes.
      -- markdown_inline matters more than it looks: `markdown` injects it for code
      -- fences and inline spans, and it was missing from the old parser set.
      ts.install({
        "bash", "css", "diff", "html", "javascript", "json", "lua", "markdown",
        "markdown_inline", "python", "query", "rust", "toml", "tsx", "typescript",
        "vim", "vimdoc", "yaml",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang then
            return
          end

          -- Replaces the old `auto_install = true`: a filetype outside the list
          -- above gets its parser fetched on first sight, and highlights on reopen.
          if not vim.tbl_contains(ts.get_installed("parsers"), lang) then
            if vim.tbl_contains(ts.get_available(), lang) then
              ts.install(lang)
            end
            return
          end

          -- pcall because a parser can be present but fail to load (ABI mismatch
          -- after an upgrade). A broken parser should cost syntax color, not throw
          -- a wall of Lua on every file you open -- which is the failure you just hit.
          if pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
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
      -- Servers Mason installs into its own private directory. rust_analyzer is
      -- deliberately NOT here: rustup already ships one, and rustup's copy is
      -- version-locked to whatever toolchain the project is using. Mason's copy is
      -- a standalone binary that drifts from your toolchain, and a rust-analyzer
      -- built against a different Rust than your code produces phantom errors.
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "pyright" },
      })

      -- Tell every server what completion capabilities the client has. You already
      -- run blink.cmp, so there is no nvim-cmp here and none is needed; adding one
      -- would mean two completion engines racing for the same keys.
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- mason-lspconfig auto-enables the servers Mason installed. rust_analyzer is
      -- not one of them, so it has to be switched on by hand. lspconfig's default
      -- command is plain `rust-analyzer`, which hits the rustup shim on PATH and
      -- resolves to the active toolchain's copy. Exactly what we want.
      vim.lsp.enable("rust_analyzer")

      -- Keymaps attach only to buffers with a live LSP client, so `gd` still means
      -- plain "go to local declaration" in a buffer with no server running.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local function lsp_map(lhs, rhs, desc)
            map("n", lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local builtin = require("telescope.builtin")
          lsp_map("gd", builtin.lsp_definitions, "Go to definition")
          lsp_map("gr", builtin.lsp_references, "Find references")
          lsp_map("K", vim.lsp.buf.hover, "Hover docs")
          lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          lsp_map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
          lsp_map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
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
