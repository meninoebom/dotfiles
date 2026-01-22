# ~/.bash_profile should be super-simple and just load .profile and .bashrc (in that order)
# ~/.profile has the stuff NOT specifically related to bash, such as environment variables (PATH and friends)
. ~/.profile
# ~/.bashrc has anything you'd want at an interactive command line: Command prompt, EDITOR variable, bash aliases etc. 
. ~/.bashrc

. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"
