#frequently used commands
alias agi='sudo apt-get install'
alias pull_submodules="git submodule foreach git pull origin master"
alias lf='ls -F'
alias la="ls -a"
alias ll="ls -al"

#edit frequently used files
alias bash_profile="sublime ~/.bash_profile"
alias profile="sublime ~/.profile"
alias bashrc="sublime ~/.bashrc"
alias vhosts="sublime /Applications/XAMPP/xamppfiles/etc/extra/httpd-vhosts.conf"
alias hosts="sudo sublime /etc/hosts"	

#go to frequently used directories
alias up='cd ..'
alias desk='cd ~/Desktop'
alias dev="cd ~/dev"
alias juniper="cd ~/dev/Juniper"
alias nnpa="cd ~/dev/Juniper/jun12223_a_nnpa"
alias framework="cd ~/dev/Juniper/jun11382_framework"
alias shared="cd ~/dev/Juniper/juniper_net_global_shared"
alias netmatters="cd ~/dev/Juniper/jun11382_netmatters"
alias people="cd ~/dev/people/public/wp-content/ && sublime themes/thepeople && compass watch themes/thepeople"
alias motion="cd ~/dev/oh12103_motion_and_image/"
alias berkeley="cd ~/dev/oh12101_the_berkeley_school_feedmachine/"
alias kepler="cd ~/dev/Juniper/jun12409_kepler_roi_calculator/"
alias kepler_build="cd ~/dev/Juniper/jun12409_kepler_roi_calculator/ && yeoman build --force && rm -rf ~/kepler/ && cp -r dist/ ~/kepler/"
alias secure="cd ~/dev/Juniper/jun12342_secure_virtualization_calculator/"
alias secure_build="cd ~/dev/Juniper/jun12342_secure_virtualization_calculator/ && yeoman build --force && rm -rf ~/secure_virt/ && cp -r dist/ ~/secure_virt/"
alias caco="cd ~/dev/caco/public/wp-content/themes/caco/ && sublime . && compass watch"
alias demandgen="cd ~/dev/Juniper/jun13051_demand_gen_form_template/ && sublime . && grunt watch"
alias flexible="cd ~/dev/Juniper/jun13051_flexible_template/"
alias simply="cd /Users/bbrown/dev/Juniper/jp_261_simply_connected/"
alias sdn="cd /Users/bbrown/dev/Juniper/sdn_flex/"
#remote servers
alias amazon="ssh bbrown@107.20.254.191" 
alias rackspace="ssh -p 33333 interactive@50.57.40.207"

