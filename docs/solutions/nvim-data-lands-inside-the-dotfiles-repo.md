# Tool data appears inside the dotfiles repo (hundreds of untracked files)

## Symptom

Immediately after a fresh `./init.sh`, `git status` in `~/dotfiles` shows
hundreds or thousands of untracked files under a package directory, for paths
that have nothing to do with that package. Observed on a new machine:

```
?? navi/.local/share/nvim/lazy/blink.cmp/
?? navi/.local/share/nvim/lazy/nvim-treesitter/
?? navi/.local/share/nvim/mason/packages/lua-language-server/...
```

1,274 entries, all Neovim plugin and Mason language-server files, all filed
under the `navi` package. Nothing had been edited. The machine had only been
set up and Neovim opened once.

## Root cause

GNU Stow performs **tree folding**. When the destination directory does not
already exist, stow symlinks the entire directory into the stow package rather
than creating a real directory and linking each file individually.

On a fresh machine `~/.local/share` does not exist. The `navi` package is the
only one supplying anything beneath it, so stow folded at the highest level it
could and created:

```
~/.local/share -> ~/dotfiles/navi/.local/share
```

From that point `~/.local/share` **is** the git repo. Neovim's data directory
is `~/.local/share/nvim`, so every plugin lazy.nvim cloned and every language
server Mason downloaded was written straight into the repo.

The critical property: **this depends on what already existed on the machine.**
On an older laptop where `~/.local/share` was already a real directory, stow can
only fold one level deeper, at `~/.local/share/navi`, and the problem never
appears. The same repo therefore behaves differently on two machines, and the
machine that works cannot detect the problem.

## Fix

**Permanent, in `init.sh`:** pass `--no-folding` to every stow invocation.

```bash
stow --no-folding -R -t "$HOME" "$pkg"
```

This makes stow create real directories and symlink only files, so no directory
in `$HOME` is ever an alias for a directory in this repo. The flag is documented
in `man stow` but is absent from `stow --help`; it is present in GNU Stow 2.4.1.

`init.sh` also pre-creates `~/.local/share` for the same reason.

**Cleanup on an affected machine:**

```bash
cd ~/dotfiles
readlink ~/.local/share                     # confirm it points into the repo
rm -rf ~/dotfiles/navi/.local/share/nvim    # leaked data; fully regenerable
stow -D -t ~ navi                           # drop the over-folded symlink
git checkout nvim/.config/nvim/lazy-lock.json
git pull && ./init.sh                       # re-stow with --no-folding
```

Then reopen Neovim and run `:Lazy restore` so plugins match the tracked
lockfile. Verify with `ls -ld ~/.local/share`, which must be a real directory
and not a symlink.

## Rule going forward

- Always stow with `--no-folding`. The default is convenient for simple cases
  and actively dangerous for any package whose path is also a runtime data
  directory for some tool.
- Treat a large block of untracked files after a fresh install as a structural
  problem, never as something to `git add`. Committing it would put hundreds of
  megabytes of third-party binaries into the repo permanently.
- When adding a package under `.local/share`, `.config`, or `.cache`, check
  whether any tool also writes there at runtime. If so, that path must be
  file-linked, never folded.
- A stow layout is only proven on a machine where the destination directories
  did not already exist. An existing setup cannot validate a fresh install.
