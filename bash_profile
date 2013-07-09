#.bash_profile is for making sure that both the things in .profile and .bashrc are loaded for login shells. For example, .bash_profile could be something simple like
#http://stefaanlippens.net/bashrc_and_others
. ~/.profile
. ~/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


