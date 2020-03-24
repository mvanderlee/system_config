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
declare -a dependencies=("asdf" "brew" "gem" "pip")
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

USER_HOME=$(if [ -e $SUDO_USER ]; then echo $HOME; else getent passwd $SUDO_USER | cut -d: -f6; fi)

# extra packages

# For RedHat/CentOS
if [ "$(command -v yum)" ]; then
	yum makecache fast
	yum install -y \
        bzip2 \
        bzip2-devel \
        htop \
        openssl-devel \
        patch \
        readline \
        readline-devel \
        sqlite-devel \
        unzip \
        wget \
        zlib \
        zlib-devel 
fi
# Ubuntu (force-yes for bash on windows)
if [ "$(command -v apt-get)" ]; then
	apt-get install -y --force-yes \
        htop \
        net-tools \
        openssl \
        postgresql-client \
        ssh \
        unzip \
        wget \
		zlibc \
        zlib1g \
        zlib1g-dev
else
	error "No suitable package manager found. (yum, apt-get)"
	exit 127
fi

# Set theme
info "Setting Theme"
CURRENT_PIC=$(gsettings get org.gnome.desktop.screensaver picture-uri)
if [ "$CURRENT_FONT" != "'file://$USER_HOME/Pictures/RS_Siege1.jpg'" ]; then
    wget -qO "$USER_HOME/Pictures/RS_Siege1.jpg" https://github.com/MichielVanderlee/system_config/raw/master/assets/wallpapers/RS_Siege1.jpg

    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Humanity-Dark"
    gsettings set org.gnome.desktop.background picture-uri "file://$USER_HOME/Pictures/RS_Siege1.jpg"
    gsettings set org.gnome.desktop.screensaver picture-uri "file://$USER_HOME/Pictures/RS_Siege1.jpg"
fi

# Install fonts
CURRENT_FONT=$(gsettings get org.gnome.desktop.interface monospace-font-name)
if [ "$CURRENT_FONT" != "'FuraCode Nerd Font 11'" ]; then
	info "Install Fonts"
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip
	mkdir -p $USER_HOME/.fonts/truetype/FuraCode
	unzip FiraCode.zip -d $USER_HOME/.fonts/truetype/FuraCode -x '*.otf' '*Windows Compatible.ttf'

	# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip
	# mkdir -p $HOME/.fonts/opentype/FuraMono
	# unzip FiraMono.zip -d $HOME/.fonts/opentype/FuraMono -x '*Windows Compatible.otf'

	sudo fc-cache -f -v
	gsettings set org.gnome.desktop.interface monospace-font-name "FuraCode Nerd Font 11"
fi

# Set Terminal Theme
info "Setting Terminal Theme"
wget -qO terminal.profile https://github.com/MichielVanderlee/system_config/raw/master/terminal.profile
cat terminal.profile | dconf load /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ -


pip install awscli

# pgcli
pip install pgcli

info "Installing pspg"
brew install pspg

# ptpython
if [[ ! -d "$USER_HOME/.ptpython" ]]; then
    info "Installing ptpython"
    pip install ptpython
    mkdir $USER_HOME/.ptpython
    wget -O $USER_HOME/.ptpython/config.py https://github.com/MichielVanderlee/system_config/raw/master/.ptpython-config.py
    if [ -n "$SUDO_USER" ]; then 
        chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.ptpython
    fi
fi

# colorls
info "Installing colorls"
gem install colorls
rbenv rehash
rehash

# ammonite-repl
curl -L https://github.com/lihaoyi/Ammonite/releases/download/1.6.9/2.13-1.6.9 > /usr/local/bin/amm
chmod +x /usr/local/bin/amm

# docker
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce

curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

sysctl -w vm.max_map_count=262144

# echo "Installing rust"
# curl https://sh.rustup.rs -sSf | sh

# install `rq`
# curl -LSfs https://japaric.github.io/trust/install.sh | sh -s -- --git dflemstr/rq