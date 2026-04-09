# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). One source of truth, symlinked into `$HOME`.

## Fresh machine setup

```bash
git clone git@github.com:meninoebom/dotfiles.git ~/dotfiles
cd ~/dotfiles
./init.sh
exec zsh
```

`init.sh` is idempotent — safe to re-run any time. It installs everything in `Brewfile`, backs up colliding files, and stows every package.

## Stack

- **Shell**: Zsh + [Antidote](https://getantidote.github.io/) plugin manager
- **Prompt**: [Starship](https://starship.rs/)
- **Navigation**: [Zoxide](https://github.com/ajeetdsouza/zoxide) (`z foo` jumps to frequent dirs)
- **Search**: [fzf](https://github.com/junegunn/fzf) (`Ctrl+R` history, `Ctrl+T` file picker)
- **Listing**: [eza](https://eza.rocks/) (`ls` replacement)
- **Multiplexer**: tmux
- **Editor**: stock `vim` (ships with macOS)
- **Dotfiles**: GNU Stow

## Layout

```
~/dotfiles/
├── Brewfile        # Tools required by these dotfiles
├── init.sh         # Idempotent setup script
├── zsh/            # .zshrc, .zsh_plugins.txt, .aliases.sh
├── git/            # .gitconfig, .gitignore_global
├── tmux/           # .tmux.conf
├── starship/       # .config/starship.toml
└── misc/           # .netrc
```

## Stow cheatsheet

```bash
cd ~/dotfiles

stow -t ~ <package>      # apply (creates symlinks)
stow -D -t ~ <package>   # remove (deletes symlinks)
stow -R -t ~ <package>   # restow (idempotent — fixes drift)
```
