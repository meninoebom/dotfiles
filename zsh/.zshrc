# ~/.zshrc - Antidote + Starship + Zoxide

# Bootstrap Homebrew onto PATH. There is no ~/.zprofile on this machine, so this
# is the only thing that makes `brew` resolvable, and the antidote/starship/zoxide
# lines below all depend on it. This must stay at the top -- it cannot be the
# "activated last" copy. See the PATH precedence section at the end of the file,
# which re-asserts Homebrew's position after everything else has edited PATH.
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Zsh options
setopt AUTO_CD              # Type directory name to cd into it
setopt CORRECT              # Suggest corrections for typos
bindkey -v                  # Vi keybindings (see "Keybindings" section below)

# ------------------------------------------------------------------------------
# Terminal UI ownership
# ------------------------------------------------------------------------------
# Warp does not use a standard PTY line editor. It has a custom input box that
# intercepts keystrokes before they reach ZLE, and it natively renders the
# prompt, autosuggestions, syntax highlighting and history search. Anything that
# hooks ZLE fights that input box: Warp's known-issues page names
# zsh-autosuggestions and fzf specifically. So the shell only supplies its own
# UI when the terminal isn't already providing one.
#
# herdr panes inherit TERM_PROGRAM from the server's launch env, which may be
# WarpTerminal even when viewed through another terminal. So honor the Warp
# opt-out only when NOT inside a herdr pane ($HERDR_ENV=1 is set in every pane).
#
# Referenced by name from .zsh_plugins.txt via antidote's `conditional:`
# annotation, so it must be defined before the static plugin file is sourced.
shell_owns_ui() {
  [[ "$TERM_PROGRAM" != "WarpTerminal" || -n "$HERDR_ENV" ]]
}

# ------------------------------------------------------------------------------
# Antidote Plugin Manager
# ------------------------------------------------------------------------------
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

# Initialize completion system before loading plugins.
# Antidote does NOT run compinit for us, and oh-my-zsh plugins (e.g. git)
# call `compdef` at load time, which only exists after compinit has run.
# -C skips the security check on the dump for faster startup; -d picks a cache path.
autoload -Uz compinit
compinit -C

# Generate static plugin file for performance
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
fi
source ${zsh_plugins}.zsh

# ------------------------------------------------------------------------------
# Starship Prompt (disabled in Warp, which draws its own prompt).
# ------------------------------------------------------------------------------
if shell_owns_ui; then
  eval "$(starship init zsh)"
fi

# ------------------------------------------------------------------------------
# Zoxide (smarter cd)
# ------------------------------------------------------------------------------
eval "$(zoxide init zsh)"

# ------------------------------------------------------------------------------
# FZF (binds ZLE widgets to ^R/^T/Alt-C; Warp provides its own history search)
# ------------------------------------------------------------------------------
if shell_owns_ui; then
  # Modern fzf (0.48+) generates its own shell integration; no ~/.fzf.zsh to
  # install or keep in sync. This one line binds ^R/^T/Alt-C and fuzzy completion.
  source <(fzf --zsh)
fi

# ------------------------------------------------------------------------------
# Keybindings
# ------------------------------------------------------------------------------
# Vi mode (`bindkey -v` above) leaves insert mode nearly unusable for line
# editing: zsh's viins keymap binds ^A/^E/^K to self-insert, so they type a
# literal control character. Worse, the vi-* kill widgets (vi-kill-line on ^U,
# vi-backward-kill-word on ^W, vi-backward-delete-char on backspace) refuse to
# delete past the point where insert mode began, so they silently no-op after
# leaving and re-entering insert. Warp hides all of this because its own input
# box implements these keys and never consults the keymap.
#
# Graft the emacs-style editing keys onto insert mode only. Normal mode is
# untouched, so hjkl/w/b/ciw all still work. This runs last so it wins over
# anything the plugins or fzf bind.
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^Y' yank
bindkey -M viins '^?' backward-delete-char   # backspace
bindkey -M viins '^H' backward-delete-char   # ctrl-backspace on some terminals

# ------------------------------------------------------------------------------
# Development Tools
# ------------------------------------------------------------------------------

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Java
zulu17=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
[[ -d $zulu17 ]] && export JAVA_HOME=$zulu17
unset zulu17

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Bun
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Console Ninja


# Windsurf/Codeium
[[ -d "$HOME/.codeium/windsurf/bin" ]] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# Local bin
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Tabtab completions (serverless)
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# ------------------------------------------------------------------------------
# Aliases & functions
# ------------------------------------------------------------------------------
source ~/.aliases.sh
[[ -f ~/.functions.sh ]] && source ~/.functions.sh
export PATH="$HOME/.local/bin:$PATH"

# OpenClaw Completion
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# Vite+ bin (https://viteplus.dev)
[[ -f "$HOME/.vite-plus/env" ]] && . "$HOME/.vite-plus/env"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# >>> blaze >>>
[[ -f "$HOME/.blaze/blaze.zsh" ]] && source "$HOME/.blaze/blaze.zsh"
# <<< blaze <<<

# ==============================================================================
# PATH precedence -- KEEP THESE TWO BLOCKS LAST, IN THIS ORDER
# ==============================================================================
# PATH is scanned left to right and the first match wins, so the FRONT takes
# precedence. Both blocks below prepend, which is why running them last is what
# puts them in front. Anything appended here would lose instead of win, so new
# PATH edits go ABOVE this section, not below it.
#
# This matters because the sections above prepend freely (bun, pnpm, windsurf,
# ~/.local/bin), and each one pushes Homebrew further back.

# --- 1. Homebrew --------------------------------------------------------------
# Re-assert Homebrew at the front. This is not a redundant copy of the bootstrap
# at the top of the file: this Homebrew routes shellenv through path_helper, which
# rebuilds PATH with /opt/homebrew/{bin,sbin} first and leaves every other entry in
# its existing relative order -- it re-hoists rather than duplicating. Without this
# line, ~/.local/bin and the bun/pnpm prepends sit ahead of /opt/homebrew/bin.
#
# The payoff is `bash`: Apple ships 3.2.57 at /bin/bash and never updates it
# (it is GPLv2-pinned). Homebrew's bash is 5.x, and Homebrew being in front is the
# only reason `bash` resolves to it. Scripts must use `#!/usr/bin/env bash` to
# benefit -- a hardcoded `#!/bin/bash` shebang ignores PATH and gets 3.2 anyway.
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# --- 2. mise ------------------------------------------------------------------
# mise activates dead last so it overrides everything, including Homebrew.
# `mise activate zsh` snapshots the current PATH into __MISE_ORIG_PATH and then
# re-derives PATH on every prompt from that snapshot via a precmd hook. Activating
# it any earlier would capture a stale base, and the hook would keep re-imposing
# that stale PATH on each prompt -- so this is a hard ordering requirement, not a
# stylistic one.
[[ -x /opt/homebrew/bin/mise ]] && eval "$(/opt/homebrew/bin/mise activate zsh)"
