# .profile should have the stuff NOT specifically related to bash
# such as environment variables (PATH and friends)
export EDITOR=nvim
export EC2_PRIVATE_KEY=~/.ec2/pk-67DF3XSSNPTPEOIB3VR3BATRTYVLSY2J.pem
export EC2_CERT=~/.ec2/cert-67DF3XSSNPTPEOIB3VR3BATRTYVLSY2J.pem
export EC2_HOME=~/.ec2
export PATH="/usr/local/bin:${PATH}"
export JAVA_HOME=`/usr/libexec/java_home`
export JRE_HOME=`/usr/libexec/java_home`
export NODE_PATH="/usr/local/lib/node"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export TERM="xterm-color"
