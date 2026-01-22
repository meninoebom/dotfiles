# ~/.zshrc - Antidote + Starship + Zoxide

# Zsh options
setopt AUTO_CD              # Type directory name to cd into it
setopt CORRECT              # Suggest corrections for typos

# Load Civiqs shell config (if exists)
[[ -f "${HOME}/.civiqs/etc/zshrc" ]] && source "${HOME}/.civiqs/etc/zshrc"

# ------------------------------------------------------------------------------
# Antidote Plugin Manager
# ------------------------------------------------------------------------------
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

# Generate static plugin file for performance
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
fi
source ${zsh_plugins}.zsh

# ------------------------------------------------------------------------------
# Starship Prompt (disabled in Warp which has its own prompt features)
# ------------------------------------------------------------------------------
if [[ -z "$WARP_IS_LOCAL_SHELL_SESSION" ]]; then
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
# Aliases
# ------------------------------------------------------------------------------
source ~/.aliases.sh
