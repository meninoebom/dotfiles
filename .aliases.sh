# Frequently used commands
alias vim="nvim"
alias vimdiff="nvim -d"
alias path='tr ':' '\n' <<< "$PATH"'
alias agi='sudo apt-get install'
alias lf='ls -F'
alias la="ls -a"
alias ll="ls -al"


# Edit frequently used files
alias vimrc="nvim ~/.vimrc"
alias bash_profile="nvim ~/.bash_profile"
alias profile="nvim ~/.profile"
alias bashrc="nvim ~/.bashrc"
alias hosts="sudo nvim /etc/hosts"
alias aliases="nvim ~/.aliases.sh"

# Go to frequently used directories
alias up='cd ..'
alias desk='cd ~/Desktop'
alias dev="cd ~/dev"
alias civiqs="cd ~/dev/civiqs"
alias civiqs_frontend="cd ~/dev/civiqs/civiqs_frontend"
alias admin="cd ~/dev/civiqs/admin_frontend"
alias frontend="cd ~/dev/civiqs/civiqs_frontend"
alias modeler="cd ~/dev/civiqs/civiqs_modeler"
alias questionator="cd ~/dev/civiqs/questionator"
alias ops="cd ~/dev/civiqs/ops"
alias sandbox="cd ~/dev/sandbox"
alias rrl="cd ~/dev/rap-research-lab"
alias rap="cd ~/dev/rap-research-lab"
alias api="cd ~/dev/rap-research-lab/rap-almanac-api"
alias dotfiles="cd ~/dotfiles"

# Remote servers
alias amazon="ssh bbrown@107.20.254.191"
alias rackspace="ssh -p 33333 interactive@50.57.40.207"

# Git
alias ghist="git log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias git-pull-submodules="git submodule foreach git pull origin master"

# AWS
