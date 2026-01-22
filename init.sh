#!/bin/bash
# Dotfiles setup script using GNU Stow

set -e

echo "=== Dotfiles Setup ==="

# Install required tools
echo "Installing required tools..."
brew install stow antidote starship zoxide neovim fzf

# Create backup directory
backup_dir=~/dotfiles_old_$(date +%Y%m%d_%H%M%S)
echo "Backup directory: $backup_dir"
mkdir -p "$backup_dir"

# Remove any existing symlinks/files that would conflict
echo "Cleaning up existing dotfiles..."
for file in .zshrc .zsh_plugins.txt .aliases.sh .gitconfig .gitignore_global \
            .profile .bash_profile .bashrc .tmux.conf .netrc; do
    if [ -e ~/"$file" ] || [ -L ~/"$file" ]; then
        mv ~/"$file" "$backup_dir/" 2>/dev/null || true
    fi
done

# Clean up nvim config
if [ -e ~/.config/nvim ] || [ -L ~/.config/nvim ]; then
    mv ~/.config/nvim "$backup_dir/" 2>/dev/null || true
fi

# Clean up starship config
if [ -e ~/.config/starship.toml ] || [ -L ~/.config/starship.toml ]; then
    mv ~/.config/starship.toml "$backup_dir/" 2>/dev/null || true
fi

# Ensure .config directory exists
mkdir -p ~/.config

# Apply stow packages
echo "Applying stow packages..."
cd ~/dotfiles
stow -t ~ zsh
stow -t ~ nvim
stow -t ~ git
stow -t ~ shell
stow -t ~ tmux
stow -t ~ starship
stow -t ~ misc

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Restart your terminal (or run: exec zsh)"
echo "2. Open nvim and run :Lazy to install plugins"
echo "3. Test zoxide: z <directory>"
echo ""
