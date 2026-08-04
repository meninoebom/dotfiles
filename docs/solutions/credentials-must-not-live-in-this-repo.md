# A credential was committed to this repo

## Symptom

A file holding a live credential is tracked in this repository. Found on
2026-08-04: `misc/.netrc`, containing a login email and a 32-character hex auth
token for `surge.surge.sh`, committed since `b10ec02` ("Modernize dotfiles").

This repo is **public** (`github.com/meninoebom/dotfiles`). Anything committed
here is world-readable the moment it is pushed, and public dotfiles repos are
routinely scraped for exactly this kind of file.

Nothing surfaced this as an error. `git status` was clean, `init.sh` ran without
complaint, and the credential worked. It was only found by reading the tracked
file list and asking what each entry was for.

## Root cause

Two separate mistakes compounded.

1. **A credential file was treated as configuration.** `.netrc` looks like a
   dotfile, so it got stowed like one. But it holds a secret, not a preference.
   The distinction that matters is not "is it a dotfile" but "would I mind if a
   stranger read it."
2. **Nothing enforced the policy that already existed.** The Brewfile installs
   Doppler and describes it as the "source of truth for secrets," so the rule
   was already decided. `.netrc` predated it and no `.gitignore` rule or check
   existed to catch the drift. A policy that lives only in a comment is not
   enforced.

The credential was also mode `644` — world-readable on a multi-user machine.
`.netrc` is conventionally `600`, and some tools refuse to read one with looser
permissions.

Aggravating detail: the token was for a tool that was not installed and not used
anywhere. `surge` was absent from `PATH`, from the Brewfile, and from every
config file. The repo was carrying live credential exposure for zero benefit.

## Fix

Applied in this order. **Rotation comes first** — until the exposed credential
is dead, everything else is housekeeping.

1. **Revoke the exposed credential at the provider.** Assume it is compromised.
   Do not skip this because the history was rewritten; the old commits may
   already exist in clones, forks, and provider-side caches.
2. **Remove the file.** `.netrc` was the only file in the `misc` package, so the
   whole package went:

   ```bash
   stow -D -t "$HOME" misc   # remove the ~/.netrc symlink
   git rm -r misc
   ```

   Then drop `misc` from `PACKAGES` in `init.sh` and remove `.netrc` from its
   backup loop.
3. **Add a guard** so it cannot recur silently. `.gitignore` now covers
   `.netrc`, `.env*`, `*.pem`, `*.key`, and common private key names.
4. **Purge it from history** with `git filter-repo`, then force-push. This
   rewrites every commit SHA from the affected commit onward, so other clones
   must re-clone or hard-reset — see below.

## Consequence for other machines

A history rewrite changes commit SHAs. Any other machine with a clone will have
a divergent `main` and cannot fast-forward. On each one:

```bash
cd ~/dotfiles
git fetch origin
git reset --hard origin/main
```

Then remove the stale symlink left behind by the deleted package:

```bash
rm -f ~/.netrc
```

Do not `git pull` on a machine with a divergent history — it creates a merge
that reintroduces the leaked blob.

## Rule going forward

Credentials never enter this repo, not even ignored. They live in Doppler, or as
untracked machine-local files recreated by hand. If a tracked file would need a
real secret to function, commit a `.template` with empty values instead.

A useful check before any commit that adds a file: **would I mind if a stranger
read this?** If the answer is anything but a flat no, it does not belong here.
