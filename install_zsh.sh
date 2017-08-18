#!/bin/bash

# For RedHat/CentOS
if [ "$(command -v yum)" ]; then
	yum makecache fast
	yum install -y \
		git \
		wget \
		zsh
# Ubuntu (force-yes for bash on windows)
elif [ "$(command -v apt-get)" ]; then
	apt-get install -y --force-yes \
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
mkdir ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh

wget -N -P ~/ https://github.com/DDuTCH/babun_config/raw/master/.zshrc

# usermod -s /bin/zsh root
echo "Please log out, then log in again."
echo "If zsh isn't automatically set as your default shell, run:"
echo "usermod -s /bin/zsh <username>"
