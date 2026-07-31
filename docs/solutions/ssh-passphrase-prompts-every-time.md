# SSH asks for the key passphrase over and over

## Symptom

After putting a passphrase on an SSH key, every `git push`, `git pull`, or `ssh`
prompts for it again. On a machine with a working setup this never happens, so
it reads like something is broken rather than something is missing.

## Root cause

Two mechanisms have to be in place, and they solve different halves of the
problem. Having neither, or only the first, produces repeated prompts.

1. **ssh-agent** holds the decrypted key in memory. Once a key is loaded, ssh
   asks the agent instead of asking you. Its memory does not survive a reboot.
2. **The macOS login Keychain** stores the passphrase itself, encrypted, and
   releases it after you log in. This is the half that survives reboots. Without
   it you re-enter the passphrase once per boot, forever.

This is per-machine configuration. `~/.ssh/config` is deliberately not tracked in
this repo, because SSH identity is machine-specific and work and personal
machines are kept separate on purpose. That is why a new machine has none of it.

## Fix

Run on the machine that is prompting. Nothing here copies keys or identity
between machines.

Create `~/.ssh/config`:

```
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
```

- `AddKeysToAgent yes` loads the key into the agent on first use.
- `UseKeychain yes` reads the passphrase from the Keychain instead of prompting.
- `IdentitiesOnly yes` offers only this key, avoiding GitHub's "too many
  authentication failures" when several keys are present.

Then:

```bash
chmod 600 ~/.ssh/config                        # ssh ignores a config it deems insecure
ssh-add --apple-use-keychain ~/.ssh/id_ed25519 # prompts once, then stores it
```

Verify:

```bash
ssh-add -l              # lists the loaded key
ssh -T git@github.com   # greets you by username, no prompt
```

Adjust `IdentityFile` and the `ssh-add` path if the key is not named
`id_ed25519`; check with `ls ~/.ssh/`.

## Rule going forward

- `UseKeychain` is an Apple patch, not upstream OpenSSH. On Linux it hard-errors
  with "Bad configuration option", so strip that line if this config is ever
  reused there.
- The older `ssh-add -K` spelling is deprecated in favor of
  `--apple-use-keychain`. Both work on current macOS.
- Keep the passphrase. It is what makes a stolen laptop not hand over the
  GitHub identity. The Keychain does not weaken it: the passphrase stays
  encrypted at rest and is only released after machine login.
