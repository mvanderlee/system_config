#!/bin/bash

set -e

USER_HOME=$(if [ -e $SUDO_USER ]; then echo $HOME; else getent passwd $SUDO_USER | cut -d: -f6; fi)

# Install packages
apt update
apt upgrade
apt install \
  automake \
  autoconf \
  bison \
  build-essential \
  curl \
  file \
  git \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libncurses5-dev \
  libpq-dev \
  libsqlite3-dev \
  libssl-dev \
  libreadline7 \
  libreadline-dev \
  libtool \
  libyaml-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libxslt-dev \
  llvm \
  tk-dev \
  unixodbc-dev \
  unzip \
  wget \
  xz-utils \
  zlibc \
  zlib1g \
  zlib1g-dev

# Install zsh
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_zsh.sh | sudo bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $USER_HOME/.zprofile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install gcc
brew install jq
brew install openssl readline sqlite3 xz zlib

# Install adsf
brew install asdf

# Install plugins
asdf_install() {
  # Get latest version so we can install and set it as global
  if [ "$2" ]; then
    latest="$(asdf latest $1 $2)"
  else
    latest="$(asdf latest $1)"
  fi
  # default to passed in version. (needed for java)
  if [ ! "$latest" ]; then
    latest="$2"
  fi

  asdf plugin-add "$1"
  asdf install "$1" "$latest"
  asdf global "$1" "$latest"
}

asdf_install golang
asdf_install java adopt-openjdk-8u242-b08
asdf_install maven
asdf_install nodejs 12
asdf_install python 2.7
asdf_install python 3.7
asdf_install ruby

# Install tmux
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_tmux.sh | sudo bash
# Install vim 
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_vim.sh | sudo bash