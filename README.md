# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

### Fresh Machine Setup
```bash
git clone git@github.com:meninoebom/dotfiles.git ~/dotfiles
cd ~/dotfiles
./init.sh
```

### Restart Shell
```bash
exec zsh
```

### First-Time NeoVim Setup
```bash
nvim
# lazy.nvim auto-installs on first launch
# Then run :Lazy sync
```

## New Commands

| Command | What it does |
|---------|-------------|
| `z <dir>` | Jump to frequently used directories (learns as you use) |
| `zi` | Interactive directory picker with fzf |
| `:Lazy` | In nvim: manage plugins |

## Directory Structure

```
~/dotfiles/
├── zsh/        # Zsh config (antidote + Starship + zoxide)
│   ├── .zshrc
│   ├── .zsh_plugins.txt
│   └── .aliases.sh
├── nvim/       # NeoVim config (lazy.nvim, Lua-based)
│   └── .config/nvim/
│       ├── init.lua
│       └── lua/
│           ├── config/     # options, keymaps, autocmds
│           └── plugins/    # plugin specs
├── git/        # Git config
│   ├── .gitconfig
│   └── .gitignore_global
├── shell/      # Bash/profile configs
│   ├── .profile
│   ├── .bash_profile
│   └── .bashrc
├── tmux/       # Tmux config
│   └── .tmux.conf
├── starship/   # Starship prompt config
│   └── .config/starship.toml
└── misc/       # Other dotfiles
    └── .netrc
```

## Stow Commands

```bash
cd ~/dotfiles

# Apply a package (creates symlinks)
stow -t ~ <package>

# Remove a package (removes symlinks)
stow -D -t ~ <package>

# Re-stow (fix conflicts after editing)
stow -R -t ~ <package>

# Apply all packages
stow -t ~ zsh nvim git shell tmux starship misc
```

## Stack

- **Shell**: Zsh + [Antidote](https://getantidote.github.io/) (plugin manager)
- **Prompt**: [Starship](https://starship.rs/)
- **Navigation**: [Zoxide](https://github.com/ajeetdsouza/zoxide) (smarter cd)
- **Editor**: NeoVim + [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Dotfiles**: [GNU Stow](https://www.gnu.org/software/stow/)

## If Something Breaks

```bash
# Remove all stow symlinks
cd ~/dotfiles
stow -D -t ~ zsh nvim git shell tmux starship misc

# Restore from backup (if available)
ls ~/dotfiles_backup_*
```
