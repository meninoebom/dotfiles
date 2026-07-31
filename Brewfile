# Everything a machine needs to be a working machine: tools these dotfiles call
# directly, plus the daily toolchain. If something is installed by hand and left
# out of here, it works on that one laptop and nowhere else, and the gap only
# surfaces on a fresh machine. See docs/solutions/fresh-machine-missing-tools.md
#
# Install with: brew bundle install --file=~/dotfiles/Brewfile

# Dotfile management
brew "stow"

# Shell + prompt
brew "antidote"
brew "starship"

# Navigation + search
brew "zoxide"      # smarter cd — `z foo` jumps to frequent dirs
brew "fzf"         # fuzzy finder — Ctrl+R history, Ctrl+T file picker
brew "eza"         # modern ls replacement
brew "ripgrep"     # `rg` — fast recursive grep, respects .gitignore

# Reading + remembering
brew "glow"        # render markdown beautifully in the terminal
brew "navi"        # cheatsheet picker; cheats live in ~/.local/share/navi/cheats/

# Editor + multiplexer
brew "neovim"      # `nvim`; the nvim/ stow package and the zshrc/aliases shortcuts need it
brew "tree-sitter-cli"  # required by nvim-treesitter's `main` branch to build parsers
brew "node"        # npm is how Mason installs ts_ls and pyright; without it they fail silently
brew "tmux"
brew "herdr"       # agent multiplexer; cheatsheet lives in navi/…/herdr.cheat

# Terminal
cask "ghostty"

# Diagram rendering (for the `diagram` zsh function).
# Uses mermaid.ink (web service) so no chromium dependency needed.
brew "chafa"         # inline image viewer for any terminal

# ------------------------------------------------------------------------------
# Called directly by files in this repo. These are hard dependencies: without
# them a script or alias in here fails.
# ------------------------------------------------------------------------------
brew "gum"         # bin/.local/bin/ports needs it for sweep mode
brew "docker"      # the dps/containers/images/dstop aliases in .aliases.sh
brew "docker-compose"
brew "pandoc"      # documented in navi/…/pandoc.cheat

# ------------------------------------------------------------------------------
# Git + GitHub
# ------------------------------------------------------------------------------
brew "gh"
brew "lazygit"

# ------------------------------------------------------------------------------
# Secrets + environment
# ------------------------------------------------------------------------------
brew "doppler"     # source of truth for secrets; .env is a regenerable cache
brew "direnv"

# ------------------------------------------------------------------------------
# Language runtimes + version management
# (node is above, next to neovim, because Mason depends on npm)
# ------------------------------------------------------------------------------
brew "mise"
brew "uv"
brew "go"

# ------------------------------------------------------------------------------
# Cloud + deploy CLIs
# ------------------------------------------------------------------------------
brew "flyctl"
brew "railway"
brew "awscli"
brew "supabase"
brew "neonctl"
brew "stripe-cli"

# ------------------------------------------------------------------------------
# Everyday utilities
# ------------------------------------------------------------------------------
brew "bat"         # cat with syntax highlighting
brew "yq"          # jq for YAML
brew "just"        # command runner
brew "tree"
brew "htop"
brew "pre-commit"
brew "watchman"
brew "libpq"       # psql and friends without a full server install
