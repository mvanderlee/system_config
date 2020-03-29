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


# Install packages
info "Updating packages"
sudo apt update
sudo apt upgrade -y

info "Installing packages"
sudo apt install -y \
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
info "Installing ZSH"
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_zsh.sh | bash

# Install Homebrew
info "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.zprofile
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.profile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install gcc
brew install jq
brew install openssl readline sqlite3 xz zlib

# Install adsf
info "Installing asdf"
brew install asdf
echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.bashrc
echo -e "\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> ~/.bashrc

# Install plugins
asdf_install() {
  info "  - Installing $1"
  asdf plugin-add "$1"

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

  asdf install "$1" "$latest"
  asdf global "$1" "$latest"
}

info "Installing asdf plugins"
asdf_install golang
asdf_install java adopt-openjdk-8u242-b08
asdf_install maven
asdf_install ruby

info "Installing nodejs"
# NodeJS requires installing of pgp keys.
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs latest:12
asdf global nodejs "$(asdf latest nodejs 12)"

# PyEnv - because asdf does not support virtual environment, yet! - https://github.com/asdf-vm/asdf/issues/636
export PYENV_ROOT="$HOME/.pyenv"
git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv
git clone https://github.com/momo-lab/pyenv-install-latest.git $PYENV_ROOT/plugins/pyenv-install-latest
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"  
eval "$(pyenv virtualenv-init -)"
pyenv install-latest 2.7
pyenv install-latest 3.7
pyenv global "$(pyenv install-latest --print 3.7)" "$(pyenv install-latest --print 2.7)"

# Install vim 
info "Installing Vim"
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_vim.sh | bash
# Install tmux
info "Installing Tmux"
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_tmux.sh | bash

# Install tools
info "Installing tools"
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_tools.sh | bash