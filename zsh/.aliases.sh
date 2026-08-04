# Shared aliases — these should make sense on every machine.
#
# Machine-specific aliases (project directories, remote hosts, local services)
# belong in ~/.aliases.local.sh, which is untracked and never syncs.
#
# Directory jumping is mostly handled by zoxide (`z <partial-name>`), which
# learns paths as you visit them and needs no per-machine config. Prefer that
# over adding a `cd` alias here.

# Frequently used commands
alias path='tr ":" "\n" <<< "$PATH"'
alias ls="eza"
alias lv="eza -1"
alias lva="eza -1 --all"
alias lt='eza --tree'
alias lta='eza --tree --all'

# Edit frequently used files
alias hosts="sudo nvim /etc/hosts"
alias aliases="nvim ~/.aliases.sh"
alias aliases-local="nvim ~/.aliases.local.sh"
alias zshrc="nvim ~/.zshrc"

# Go to frequently used directories
alias up="cd .."
alias desk="cd ~/Desktop"
alias dev="cd ~/dev"
alias dotfiles="cd ~/dotfiles"

# Git
alias ghist="git log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias git-pull-submodules="git submodule foreach git pull origin master"
alias gpush='git push'
alias gpull='git pull'

# Docker
alias dps='docker ps --format "table {{.Names}}\t{{.Ports}}"'
alias containers='docker ps --format "table {{.Names}}\t{{.Ports}}"'
alias images='docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"'
alias dstop='docker stop $1'
alias drm='docker rm $1'
alias dstopall='docker stop $(docker ps -q)'
alias dkillf='docker kill $1'

# Claude Code
alias cc='claude --dangerously-skip-permissions'
alias cc-config='cd ~/.claude/'
alias commands='cd ~/.claude/commands/'
alias knowledge='cd ~/.claude/knowledge-base/'
alias agents='cd ~/.claude/agents/'

# ------------------------------------------------------------------------------
# Machine-local aliases (untracked, never syncs between machines)
# ------------------------------------------------------------------------------
# To promote a local alias to every machine, move the line up into this file and
# commit it. To demote one, move it down into ~/.aliases.local.sh.
[[ -f ~/.aliases.local.sh ]] && source ~/.aliases.local.sh
