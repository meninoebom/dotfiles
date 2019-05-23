export EDITOR=vim
export EC2_PRIVATE_KEY=~/.ec2/pk-67DF3XSSNPTPEOIB3VR3BATRTYVLSY2J.pem
export EC2_CERT=~/.ec2/cert-67DF3XSSNPTPEOIB3VR3BATRTYVLSY2J.pem
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin:$HOME/.rvm/bin
#export PATH="/usr/local/bin:$PATH" 
export PATH="/usr/local/mysql/bin:$PATH" #stole this, betting it will let me run mysql commands 
# export PATH="/usr/local/share/npm/bin:$PATH" #some node modules have executables
# export PATH="/usr/local/bin/node:$PATH" #trying to get sublime to find node commands in my path (I think)
export PATH="/usr/local/heroku/bin:$PATH" ### Added by the Heroku Toolbelt
export JAVA_HOME=`/usr/libexec/java_home`
export NODE_PATH="/usr/local/lib/node"

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export TERM="xterm-color"

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#PS1='\[\e[0;33m\] \u \[\e[0m\] @ \[\e[0;32m\] \h \[\e[0m\] : \[\e[0;34m\] \w \[\e[0m\] \$ '
PS1="\[\e[3;32m\]\w\[\e[0;33m\]\$(parse_git_branch)\[\e[0;36m\] ->\[\e[m\] "
#export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export WORKON_HOME=$HOME/Envs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

export PATH="/usr/local/bin:${PATH}"

JRE_HOME=$(/usr/libexec/java_home)
export JRE_HOME

JAVA_HOME=(/usr/libexec/java_home)
export JAVA_HOME 
