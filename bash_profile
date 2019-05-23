#.bash_profile is for making sure that both the things in .profile and .bashrc are loaded for login shells. For example, .bash_profile could be something simple like
#. ~/.profile
#. ~/.bashrc
#http://stefaanlippens.net/bashrc_and_others

. ~/.profile
. ~/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
source "/usr/local/bin/virtualenvwrapper.sh"

# path for Oracle JVM so that elastic search will run https://github.com/Homebrew/homebrew/issues/29610n (bottom of the page)
export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

# Work around bug in browserify
ulimit -n 2560

if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi
