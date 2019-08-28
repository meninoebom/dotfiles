export EDITOR=nvim
export EC2_PRIVATE_KEY=~/.ec2/pk-67DF3XSSNPTPEOIB3VR3BATRTYVLSY2J.pem
export EC2_CERT=~/.ec2/cert-67DF3XSSNPTPEOIB3VR3BATRTYVLSY2J.pem
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin:$HOME/.rvm/bin
export PATH="/usr/local/mysql/bin:$PATH" #stole this, betting it will let me run mysql commands
export PATH="/usr/local/heroku/bin:$PATH" ### Added by the Heroku Toolbelt
export PATH="/usr/local/bin:${PATH}"
export JAVA_HOME=`/usr/libexec/java_home`
export JRE_HOME=`/usr/libexec/java_home`
export NODE_PATH="/usr/local/lib/node"

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export TERM="xterm-color"

######################################################
# Legacy shit that I am absolutely clueless absolutely

# Python Virtual Env ... I think
# export WORKON_HOME=$HOME/Envs
# export PROJECT_HOME=$HOME/Devel
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# source /usr/local/bin/virtualenvwrapper.sh

# Elastic Search ... maybe

# path for Oracle JVM so that elastic search will run https://github.com/Homebrew/homebrew/issues/29610n (bottom of the page)
# export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

# Git Completion ... wtf
# source ~/.git-completion.bash

# RVM Clusterfuck

# export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*%
