
export EC2_PRIVATE_KEY=~/.ec2/pk-67DF3XSSNPTPEOIB3VR3BATRTYVLSY2J.pem
export EC2_CERT=~/.ec2/cert-67DF3XSSNPTPEOIB3VR3BATRTYVLSY2J.pem
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin:$HOME/.rvm/bin
export PATH="/usr/local/mysql/bin:$PATH" #stole this, betting it will let me run mysql commands 
export PATH="/usr/local/share/npm/bin:$PATH" #some node modules have executables
export PATH="/usr/local/bin/node:$PATH" #trying to get sublime to find node commands in my path (I think)
export JAVA_HOME=`/usr/libexec/java_home`
export NODE_PATH="/usr/local/lib/node"


#export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting