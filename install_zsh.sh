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

# antigen
mkdir $HOME/.antigen
curl -L git.io/antigen > $HOME/.antigen/antigen.zsh

wget https://github.com/MichielVanderlee/system_config/raw/master/.zshrc -O $HOME/.zshrc
wget https://github.com/MichielVanderlee/system_config/raw/master/.powerlevel9k -O $HOME/.powerlevel9k

chsh -s $(which zsh) $(whoami)

# usermod -s /bin/zsh root
# echo "Please log out, then log in again."
# echo "If zsh isn't automatically set as your default shell, run:"
# echo "chsh -s $(which zsh)"

# For WSL, edit the shortcut for wsltty to start /bin/zsh
#echo "usermod -s /bin/zsh <username>"
