# ~/.zshrc - Antidote + Starship + Zoxide

# Ensure Homebrew is on PATH (needed when .zprofile isn't sourced, e.g. IDE terminals)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Zsh options
setopt AUTO_CD              # Type directory name to cd into it
setopt CORRECT              # Suggest corrections for typos
bindkey -v                  # Vi keybindings

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
# Starship Prompt (disabled in Warp which has its own prompt features).
# herdr panes inherit TERM_PROGRAM from the server's launch env, which may be
# WarpTerminal even when viewed through another terminal — so honor the Warp
# opt-out only when NOT inside a herdr pane ($HERDR_ENV=1 is set in every pane).
# ------------------------------------------------------------------------------
if [[ "$TERM_PROGRAM" != "WarpTerminal" || -n "$HERDR_ENV" ]]; then
  eval "$(starship init zsh)"
fi

# ------------------------------------------------------------------------------
# Zoxide (smarter cd)
# ------------------------------------------------------------------------------
eval "$(zoxide init zsh)"

# ------------------------------------------------------------------------------
# FZF
# ------------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ------------------------------------------------------------------------------
# Development Tools
# ------------------------------------------------------------------------------

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Bun
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Console Ninja


# Windsurf/Codeium
export PATH="/Users/brandon/.codeium/windsurf/bin:$PATH"

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
source "/Users/brandon/.openclaw/completions/openclaw.zsh"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# pnpm
export PNPM_HOME="/Users/brandon/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# >>> blaze >>>
source /Users/brandon/.blaze/blaze.zsh
# <<< blaze <<<
