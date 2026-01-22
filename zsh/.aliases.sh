# Frequently used commands
alias vim="nvim"
alias nv="nvim"
alias vimdiff="nvim -d"
alias path='tr ':' '\n' <<< "$PATH"'
alias agi="sudo apt-get install"
alias ls="eza"
alias lf="ls -F"
alias lv="eza -1"
alias la="eza -a"
alias lva="eza -1 --all"
alias lt='eza --tree'
alias lta='eza --tree --all'
alias ltg='eza --tree --git'
alias lti='eza --tree --icons'
alias ltl='eza --tree --long --git --icons'

# Edit frequently used files
alias vimrc="nvim ~/.config/nvim/init.lua"
alias bash_profile="nvim ~/.bash_profile"
alias profile="nvim ~/.profile"
alias bashrc="nvim ~/.bashrc"
alias hosts="sudo nvim /etc/hosts"
alias aliases="nvim ~/.aliases.sh"
alias zshrc="nvim ~/.zshrc"
alias slim="cd ~/dev/prompt-caching/slim-token"

# Go to frequently used directories
alias up="cd .."
alias dev="cd ~/dev"
alias desk="cd ~/Desktop"
alias civiqs="cd ~/dev/civiqs/code"
alias config="cd ~/dev/civiqs/config"
alias sandbox="cd ~/dev/sandbox"
alias rap="cd ~/dev/rap-research-lab"
alias dotfiles="cd ~/dotfiles"
alias snipster="cd ~/dev/snipster"
alias prep="cd ~/dev/interview-prep"
alias interview="cd ~/dev/interview-prep"
alias advent="cd ~/dev/interview-prep/advent-of-code"
alias breadcrumbs="cd ~/dev/breadcrumbs"
alias ralf="cd ~/dev/ralf"


# Remote servers
alias amazon="ssh bbrown@107.20.254.191"

# Git
alias ghist="git log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias git-pull-submodules="git submodule foreach git pull origin master"
alias gpush='git push'
alias gpull='git pull'

alias dps='docker ps --format "table {{.Names}}\t{{.Ports}}"'
alias containers='docker ps --format "table {{.Names}}\t{{.Ports}}"'
alias images='docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"'

# Docker
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
