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
declare -a dependencies=("asdf" "pip")
deps_missing=false
for i in "${dependencies[@]}"; do
    if [ ! "$(command -v $i)" ]; then
        error "Dependency '$i' is missing!"
        deps_missing=true
    fi
done
if [ "$deps_missing" = true ]; then
	exit 127
fi


# For RedHat/CentOS
if [ "$(command -v yum)" ]; then
	sudo yum install -y \
		epel-release \
		yum-utils

	sudo yum makecache fast
	# yum groupinstall -y "Development Tools"
	# https://access.redhat.com/discussions/1262603
	sudo yum group install "Development Tools" --setopt=group_package_types=mandatory,default,optional
	sudo yum install -y \
		wget \
		vim \
		cmake \
		libffi-devel \
		libcurl-devel \
		openssl-devel \
		socat \
		xorg-x11-server-utils \
		unzip
# Ubuntu (force-yes for bash on windows)
elif [ "$(command -v apt-get)" ]; then
	sudo apt-get install -y --force-yes \
		wget \
		vim \
		build-essential \
		cmake \
		libffi-dev \
		socat \
		unzip \
		x11-xserver-utils
else
	error "No suitable package manager found. (yum, apt-get)"
	exit 127
fi

# Install neovim
asdf plugin-add neovim
asdf install neovim latest
asdf global neovim "$(asdf latest neovim)"

# Install neovim dependencies
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

pip install pynvim jedi

mkdir -p $HOME/.config/nvim
wget https://github.com/MichielVanderlee/system_config/raw/master/.vimrc -O $HOME/.vimrc
wget https://github.com/MichielVanderlee/system_config/raw/master/init.vim -O $HOME/.config/nvim/init.vim
wget https://github.com/MichielVanderlee/system_config/raw/master/vim.zip 
unzip vim.zip -d $HOME
rm vim.zip

info "Open nvim and run :PlugInstall"