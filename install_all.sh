#!/bin/bash

set -e

usage() {
cat << EOF
usage:  options

This script install an opinionated debian environment.

OPTIONS:
  --all                   Install everything
  --tools                 Install tools
  --tmux                  Install tmux
  --vim                   Install vim
  --zsh                   Install zsh    
  -co,  --configure-only  Configure only, don't install anything
  -h,   --help            Show this message
EOF
}

CONFIGURE_ONLY=false
INSTALL_ALL=false
INSTALL_VIM=false
INSTALL_TMUX=false
INSTALL_TOOLS=false
INSTALL_ZSH=false

base_packages=(
  automake
  autoconf
  bison
  build-essential
  curl
  file
  git
  libbz2-dev
  libffi-dev
  liblzma-dev
  libncurses5-dev
  libpq-dev
  libsqlite3-dev
  libssl-dev
  libreadline7
  libreadline-dev
  libtool
  libyaml-dev
  libxml2-dev
  libxmlsec1-dev
  libxslt-dev
  linux-headers-generic
  llvm
  tk-dev
  unixodbc-dev
  unzip
  wget
  xdg-utils
  xz-utils
  zlibc
  zlib1g
  zlib1g-dev
)

tools_packages=(
  htop
  net-tools
  openssl
  postgresql-client
  ssh
)

vim_packages=(
  cmake
  python3-pip
  socat
  vim
  x11-xserver-utils
)

zsh_packages=(
  libuser
  zsh
)

brew_base_packages=(
  gcc
  jq
  openssl 
  readline 
  sqlite3 
  xz 
  zlib
)

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

asdf_install() {
  # Performs asdf installs and set the installed version as the global version
  # asdf_install [plugin] (version)
  # If version is not defined, will install the latest version

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

perform_system_update() {
  info "Updating packages"
  sudo apt update
  sudo apt upgrade -y
}

install_packages() {
  info "Installing system packages"

  packages="${base_packages[@]}"
  if [ $INSTALL_ALL = true ]; then
    packages="${packages} ${tools_packages[@]} ${vim_packages[@]} ${zsh_packages[@]}"
  else
    if [ $INSTALL_TOOLS = true ]; then
      packages="${packages} ${tools_packages[@]}"
    fi
    if [ $INSTALL_VIM = true ]; then
      packages="${packages} ${vim_packages[@]}"
    fi
    if [ $INSTALL_ZSH = true ]; then
      packages="${packages} ${zsh_packages[@]}"
    fi
  fi

  sudo apt install -y ${packages}

  info "Installed system packages"
}

install_homebrew() {
  if [ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" </dev/null
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.zprofile
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.profile
    info "Installed Homebrew"
  else
    debug "Homebrew is already installed, skipping..."
  fi
  
  if [ ! "$(command -v brew)" ]; then
    info "Sourcing brew"
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  fi

  info "Installing Homebrew base packages"
  brew install "${brew_base_packages[@]}"
  info "Installed Homebrew base packages"
}

install_adsf() {
  install_homebrew
  if [ ! -f "$(brew --prefix asdf)/asdf.sh" ]; then
    info "Installing asdf"

    brew install asdf
    echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.bashrc
    echo -e "\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> ~/.bashrc
    info "Installed asdf"
  else
    debug "asdf is already installed, skipping..."
  fi

  if [ ! "$(command -v asdf)" ]; then
    info "Sourcing asdf"
    . $(brew --prefix asdf)/asdf.sh
  fi
}

install_zsh() {
  info "Installing ZSH"
  sudo apt install -y "${zsh_packages[@]}"
}

configure_zsh() {
  info "Configuring ZSH"
  # Install Antigen - https://github.com/zsh-users/antigen
  mkdir -p $HOME/.antigen
  curl -L git.io/antigen > $HOME/.antigen/antigen.zsh

  wget https://github.com/MichielVanderlee/system_config/raw/master/.zshrc -O $HOME/.zshrc
  wget https://github.com/MichielVanderlee/system_config/raw/master/.powerlevel9k -O $HOME/.powerlevel9k

  info "Updating shell"
  sudo chsh -s $(which zsh) $(whoami)
}

install_vim() {
  info "Installing Vim and Neovim"
  install_adsf

  asdf plugin-add neovim
  asdf install neovim latest
  asdf global neovim "$(asdf latest neovim)"

  info "Installed Vim and Neovim"
}

configure_vim() {
  info "Configuring Vim and NeoVim"
  # Install vim & neovim dependencies
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Need to install via the vim linked python, not pyenv's python
  /usr/bin/python3 -m pip install --user \
    pynvim \
    black \
    jedi

  mkdir -p $HOME/.config/nvim
  wget https://github.com/MichielVanderlee/system_config/raw/master/.vimrc -O $HOME/.vimrc
  wget https://github.com/MichielVanderlee/system_config/raw/master/init.vim -O $HOME/.config/nvim/init.vim
  wget https://github.com/MichielVanderlee/system_config/raw/master/vim.zip 
  unzip vim.zip -d $HOME
  rm vim.zip

  info "Configured Vim and NeoVim"
}

install_tmux() {
  info "Installing Tmux"
  install_adsf

  asdf plugin-add tmux
  asdf install tmux latest
  asdf global tmux "$(asdf latest tmux)"

  info "Installed Tmux"
}

configure_tmux() {
  info "Configuring Tmux"

  # Configure tmux
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
  wget https://github.com/MichielVanderlee/system_config/raw/master/.tmux.conf -O $HOME/.tmux.conf

  info "Configured Tmux"
}

install_tools() {
  info "Installing Tools"
  install_adsf
  install_pyenv

  # Install plugins
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

  pip install \
    awscli \
    pgcli

  brew install pspg

  # ptpython
  if [[ ! -d "$HOME/.ptpython" ]]; then
    info "Installing ptpython"
    pip install ptpython
    mkdir $HOME/.ptpython
    wget -O $HOME/.ptpython/config.py https://github.com/MichielVanderlee/system_config/raw/master/.ptpython-config.py
  fi

  # colorls
  info "Installing colorls"
  gem install colorls

  # ammonite-repl
  sudo curl -L https://github.com/lihaoyi/Ammonite/releases/download/1.6.9/2.13-1.6.9 -o /usr/local/bin/amm
  sudo chmod +x /usr/local/bin/amm
  
  install_docker

  sudo sysctl -w vm.max_map_count=262144

  info "Installed Tools"
}

install_pyenv() {
  info "Installing PyEnv"
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
}

install_docker() {
  info "Installing Docker"

  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce

  sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  info "Installed Docker"
}

configure_gnome_theme(){
  info "Configuring Theme"
  CURRENT_PIC=$(gsettings get org.gnome.desktop.screensaver picture-uri)
  if [ "$CURRENT_PIC" != "'file://$HOME/Pictures/RS_Siege1.jpg'" ]; then
      wget -qO "$HOME/Pictures/RS_Siege1.jpg" https://github.com/MichielVanderlee/system_config/raw/master/assets/wallpapers/RS_Siege1.jpg

      gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
      gsettings set org.gnome.desktop.interface icon-theme "Humanity-Dark"
      gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/RS_Siege1.jpg"
      gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/Pictures/RS_Siege1.jpg"
  fi

  # Install fonts
  CURRENT_FONT=$(gsettings get org.gnome.desktop.interface monospace-font-name)
  if [ "$CURRENT_FONT" != "'FuraCode Nerd Font 11'" ]; then
    info "Install Fonts"
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip
    mkdir -p $HOME/.fonts/truetype/FuraCode
    unzip FiraCode.zip -d $HOME/.fonts/truetype/FuraCode -x '*.otf' '*Windows Compatible.ttf'

    sudo fc-cache -f -v
    gsettings set org.gnome.desktop.interface monospace-font-name "FuraCode Nerd Font 11"
  fi

  # Set Terminal Theme
  info "Setting Terminal Theme"
  wget -qO terminal.profile https://github.com/MichielVanderlee/system_config/raw/master/terminal.profile
  cat terminal.profile | dconf load /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ -

  info "Configured Theme"
}

install() {
  perform_system_update
  install_packages

  if [[ $INSTALL_ALL = true || $INSTALL_TMUX = true ]]; then
    install_tmux
  fi
  if [[ $INSTALL_ALL = true || $INSTALL_TOOLS = true ]]; then
    install_tools
  fi
  if [[ $INSTALL_ALL = true || $INSTALL_VIM = true ]]; then
    install_vim
  fi
  if [[ $INSTALL_ALL = true || $INSTALL_ZSH = true ]]; then
    install_zsh
  fi
}

configure() {
  if [[ $INSTALL_ALL = true || $INSTALL_TMUX = true ]]; then
    configure_tmux
  fi
  if [[ $INSTALL_ALL = true || $INSTALL_TOOLS = true ]]; then
    os_release="$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')"
    if [ "$os_release" = 'Ubuntu' ]; then
      configure_gnome_theme
    fi
  fi
    configure_vim
  fi
  if [[ $INSTALL_ALL = true || $INSTALL_ZSH = true ]]; then
    configure_zsh
  fi
}

show_manual_next_steps() {
  if [[ $INSTALL_ALL = true || $INSTALL_TMUX = true ]]; then
    info "Open TMUX and press 'ctrl+a shift+i'. Ensure you're not nested in screen!'"
  fi
  if [[ $INSTALL_ALL = true || $INSTALL_VIM = true ]]; then
    info "Open nvim and run :PlugInstall"
  fi
}

main() {
  if [ ! $CONFIGURE_ONLY = true ]; then
    install
  fi
  configure  
  show_manual_next_steps
}

#############################################
# Parse Arguments
#############################################
while (("$#")); do
  case "$1" in
    # Add your arguments here

    --all)
      INSTALL_ALL=true
      shift
      ;;
    --tmux)
      INSTALL_TMUX=true
      shift
      ;;
    --tools)
      INSTALL_TOOLS=true
      shift
      ;;
    --vim)
      INSTALL_VIM=true
      shift
      ;;
    --zsh)
      INSTALL_ZSH=true
      shift
      ;;

    -co|--configure-only)
      CONFIGURE_ONLY=true
      shift
      ;;

    -nc|--no-color)
      COLOR_LOG=false
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

# Execute main function
main
