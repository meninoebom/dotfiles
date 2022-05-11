if [ -f ~/.aliases.sh ]; then . ~/.aliases.sh; fi

# Command Prompt Config

# Display the current git branch in command prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="\[\e[3;32m\]\w\[\e[0;33m\]\$(parse_git_branch)\[\e[0;36m\] ->\[\e[m\] "

