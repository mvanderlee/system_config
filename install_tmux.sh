#!/bin/bash

set -e

# Enable or disable colored logs
COLOR_LOG=true

## Color coded logging - https://misc.flogisoft.com/bash/tip_colors_and_formatting
error() {
  if [ $COLOR_LOG = true ]; then
    echo "[31m$1[0m"  # Red FG
  else
    echo "$1"
  fi
}

warn() {
  if [ $COLOR_LOG = true ]; then
    echo "[33m$1[0m"  # Yellow FG
  else
    echo "$1"
  fi
}

info() {
  if [ $COLOR_LOG = true ]; then
    echo "[32m$1[0m"  # Green FG
  else
    echo "$1"
  fi
}

debug() {
  if [ $COLOR_LOG = true ]; then
    echo "[36m$1[0m"  # Cyan FG
  else
    echo "$1"
  fi
}

# Check for dependencies
declare -a dependencies=("asdf")
deps_missing=0
for i in "${dependencies[@]}"; do
    if [ ! "$(command -v $i)" ]; then
        error "Dependency '$i' is missing!"
        deps_missing=1
    fi
done
if [ $deps_missing ]; then
	exit 127
fi


# For RedHat/CentOS
if [ "$(command -v yum)" ]; then
	yum makecache fast
	yum install -y \
		wget \
		git \
		gcc \
		gcc-devel \
		make \
		kernel-devel \
		ncurses-devel \
		xdg-utils
# Ubuntu (force-yes for bash on windows)
elif [ "$(command -v apt-get)" ]; then
	apt-get install -y --force-yes \
		autoconf \
		bison \
		build-essential \
		linux-headers-generic \
		libncurses5-dev \
		wget \
		xdg-utils
else
	error "No suitable package manager found. (yum, apt-get)"
	exit 127
fi

# Install tmux
asdf plugin-add tmux
asdf install tmux latest

# Configure tmux
USER_HOME=$(if [ -e $SUDO_USER ]; then echo $HOME; else getent passwd $SUDO_USER | cut -d: -f6; fi)

git clone https://github.com/tmux-plugins/tpm $USER_HOME/.tmux/plugins/tpm
wget https://github.com/MichielVanderlee/system_config/raw/master/.tmux.conf -O $USER_HOME/.tmux.conf

if [ -n "$SUDO_USER" ]; then 
	chown $SUDO_USER:$SUDO_USER $USER_HOME/.tmux.conf
	chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.tmux
fi

info "Open TMUX and press 'ctrl+a shift+i'. Ensure you're not nested in screen!'"
