#!/bin/bash

# For RedHat/CentOS
if [ "$(command -v yum)" ]; then
	yum makecache fast
	yum install -y \
		curl \
		git \
		wget \
		zsh
# Ubuntu (force-yes for bash on windows)
elif [ "$(command -v apt-get)" ]; then
	apt-get install -y --force-yes \
		curl \
		git \
		wget \
		zsh
else
	echo "No suitable package manager found. (yum, apt-get)"
	exit 127
fi

# remove files from previous version of this script
# rm -rf .oh-my-zsh .zshrc custom

USER_HOME=$(if [ -e $SUDO_USER ]; then echo $HOME; else getent passwd $SUDO_USER | cut -d: -f6; fi)

# antigen
mkdir $USER_HOME/.antigen
curl -L git.io/antigen > $USER_HOME/.antigen/antigen.zsh

wget https://github.com/MichielVanderlee/system_config/raw/master/.zshrc -O $USER_HOME/.zshrc
wget https://github.com/MichielVanderlee/system_config/raw/master/.powerlevel9k -O $USER_HOME/.powerlevel9k

if [ -n "$SUDO_USER" ]; then 
	chown $SUDO_USER:$SUDO_USER $USER_HOME/.zshrc
	chown $SUDO_USER:$SUDO_USER $USER_HOME/.powerlevel9k
	chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.antigen
fi

chsh -s $(which zsh) $(whoami)

# usermod -s /bin/zsh root
# echo "Please log out, then log in again."
# echo "If zsh isn't automatically set as your default shell, run:"
# echo "chsh -s $(which zsh)"

# For WSL, edit the shortcut for wsltty to start /bin/zsh
#echo "usermod -s /bin/zsh <username>"
