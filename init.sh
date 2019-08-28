#!/bin/bash

# Install workflow stuff
brew install zsh tmux neovim/neovim/neovim python3 ag reattach-to-user-namespace
brew tap caskroom/cask
brew cask install iterm2

# update NeoVim to support pip3 because some Vim plugins rely on it
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
pip3 install neovim

# Installing Fonts
brew tap caskroom/fonts
# brew cask install font-fira-code

# Manually setting Homebrew installed ZSH as Default Shell
# chsh -s /usr/local/bin/zsh

# Install Oh-My-Zsh (Not confident this is gonna work as of 08-27-2019)
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Remove Existing Configs
# rm -rf ~/.vim ~/.vimrc ~/.zshrc ~/.tmux ~/.tmux.conf ~/.config/nvim 2> /dev/null

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="aliases.sh bashrc bash_profile gitconfig gitconfig_global netrc profile rvmrc tmux tmux.conf vim vimrc zshrc" 
# list of files/folders to symlink in homedir

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# If NeoVim config exists, mv it 
echo "Moving NeoVim config to $olddir"
mv ~/.config/nvim/* $olddir/

# Create directories for NeoVim's config
echo "Creating directories for NeoVim config if the don't exist"
mkdir -p ~/.config ~/.config/nvim

echo "Creating symlink to for NeoVim config"
ln -s $dir/vimrc ~/.config/nvim/init.vim

echo "Creating symlink to NeoVim's config colorscheme directory"
ln -s $dir/vim/colors ~/.config/nvim/colors

# Set up vim-plug plugin manager
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

