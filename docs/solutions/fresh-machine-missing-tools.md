# A command is missing on a fresh machine

## Symptom

On a newly set up laptop, `./init.sh` completes successfully, but something is
still broken. The failure rarely names the real cause. Observed forms:

- A command simply is not found (`herdr`, `nvim`).
- An alias fails because the program it calls is absent (`zshrc`, `aliases`,
  and `hosts` all invoke `nvim`).
- A plugin throws a wall of errors that looks like a plugin bug. Neovim's
  treesitter on the `main` branch errors when `tree-sitter-cli` is missing,
  because that branch compiles parsers itself.
- `stow` aborts with "does not contain package X".

## Root cause

Two different kinds of drift, both invisible on the machine that created them.

**1. A tool was installed by hand and never added to the `Brewfile`.**
`brew install <tool>` makes it work here, forever, with no reminder that the
manifest was not updated. `brew bundle install` on a new machine installs only
what the `Brewfile` lists, so the tool never arrives. Confirmed instances:
`herdr`, `neovim`, and `tree-sitter-cli` were all installed locally and absent
from the manifest.

**2. A new package directory was never committed.**
`git commit -am` stages modifications to files git already tracks. It does not
stage new, untracked files. A new stow package added to the `PACKAGES` array in
`init.sh` therefore gets pushed as a *name* while its *contents* stay local.
`git status` shows it as `??` the whole time.

The unifying point: the machine that created the state cannot detect the missing
state, because it already has it. A fresh machine is the only honest audit.

## Fix

Immediate, on the new machine:

```bash
brew install <missing-tool>
```

Durable, on the machine that has the tool:

```bash
# 1. Find everything installed on request but absent from the manifest
grep -oE '^(brew|cask) "[^"]+"' Brewfile | sed -E 's/^(brew|cask) "//; s/"$//' | sort > /tmp/inbrewfile
{ brew leaves; brew list --cask; } | sed 's|.*/||' | sort -u > /tmp/installed
comm -13 /tmp/inbrewfile /tmp/installed

# 2. Find package directories that were never committed
git status --short | grep '^??'
```

Add what belongs, commit, push, then `git pull && ./init.sh` on the new machine.

Note that `brew leaves` lists only top-level formulae installed on request, so a
package pulled in as someone else's dependency will look "missing" from that
comparison even though it is present. Verify with `brew list --formula` before
concluding anything is absent.

## Rule going forward

- Install and manifest in the same sitting. `brew install X` is followed by
  adding `brew "X"` to the `Brewfile` and committing, not later.
- Use `git add <path>` for new package directories. `git commit -am` will
  silently skip them.
- When a config file references an external tool, that tool belongs in the
  `Brewfile` with a comment naming what needs it. A cheatsheet, an alias, or a
  plugin spec that mentions a binary is a dependency declaration.
- Before trusting a fresh-machine setup, run the two comparison commands above
  on the old machine rather than waiting to discover gaps one error at a time.
