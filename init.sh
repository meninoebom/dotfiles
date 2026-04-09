#!/usr/bin/env bash
# Dotfiles setup — idempotent, safe to re-run.
#
# What this does:
#   1. Installs required tools via Homebrew (or skips if already installed)
#   2. Backs up any pre-existing dotfiles that would collide
#   3. Symlinks every package into $HOME using GNU Stow

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
PACKAGES=(zsh git tmux starship misc)

echo "==> Dotfiles setup ($DOTFILES_DIR)"

# 1. Install Homebrew if missing, then install everything from Brewfile.
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Homebrew not found — install it from https://brew.sh first."
  exit 1
fi

if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
  echo "==> Installing tools from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
fi

# 2. Back up colliding files so Stow can do its thing.
backup_dir="$HOME/dotfiles_old_$(date +%Y%m%d_%H%M%S)"
needed_backup=false
for f in .zshrc .zsh_plugins.txt .aliases.sh .gitconfig .gitignore_global \
         .tmux.conf .netrc; do
  if [[ -f "$HOME/$f" && ! -L "$HOME/$f" ]]; then
    needed_backup=true
    mkdir -p "$backup_dir"
    mv "$HOME/$f" "$backup_dir/"
  fi
done
if [[ -f "$HOME/.config/starship.toml" && ! -L "$HOME/.config/starship.toml" ]]; then
  needed_backup=true
  mkdir -p "$backup_dir/.config"
  mv "$HOME/.config/starship.toml" "$backup_dir/.config/"
fi

if $needed_backup; then
  echo "==> Backed up colliding files to $backup_dir"
fi

mkdir -p "$HOME/.config"

# 3. Stow every package. -R is restow: idempotent.
cd "$DOTFILES_DIR"
for pkg in "${PACKAGES[@]}"; do
  echo "==> Stowing $pkg"
  stow -R -t "$HOME" "$pkg"
done

echo ""
echo "==> Done. Run 'exec zsh' to reload your shell."
