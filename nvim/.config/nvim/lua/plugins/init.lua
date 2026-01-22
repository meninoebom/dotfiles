-- Plugin specifications for lazy.nvim
return {
  -- File explorer
  {
    "preservim/nerdtree",
    cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
    keys = {
      { "`", ":NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
      { "~", ":NERDTreeFind<CR>", desc = "Find in NERDTree" },
    },
  },

  -- Fuzzy finder (fzf)
  {
    "junegunn/fzf",
    build = "./install --all",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
  },

  -- Indent guides
  {
    "Yggdroot/indentLine",
    config = function()
      vim.g.indentLine_enabled = 1
      vim.g.indentLine_char = "⟩"
    end,
  },

  -- Async linter
  {
    "dense-analysis/ale",
    config = function()
      vim.g.ale_sign_error = "●"
      vim.g.ale_sign_warning = "."
      vim.g.ale_lint_on_enter = 0
    end,
  },

  -- Status line
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    config = function()
      vim.g.airline_theme = "gruvbox"
      vim.g["airline#extensions#tabline#enabled"] = 1
      vim.g.airline_powerline_fonts = 1
      -- Powerline symbols
      vim.g.airline_left_sep = ""
      vim.g.airline_left_alt_sep = ""
      vim.g.airline_right_sep = ""
      vim.g.airline_right_alt_sep = ""
    end,
  },
  { "vim-airline/vim-airline-themes" },

  -- Comments
  { "tpope/vim-commentary" },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Syntax highlighting
  { "leshill/vim-json", ft = "json" },
  { "pangloss/vim-javascript", ft = { "javascript", "javascriptreact" } },
  { "mxw/vim-jsx", ft = { "javascript", "javascriptreact" } },
  { "tpope/vim-markdown", ft = "markdown" },

  -- Colorscheme
  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
