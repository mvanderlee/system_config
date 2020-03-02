#!/bin/bash

USER_HOME=$(if [ -e $SUDO_USER ]; then echo $HOME; else getent passwd $SUDO_USER | cut -d: -f6; fi)

# Set theme
echo "Setting Theme"
CURRENT_PIC=$(gsettings get org.gnome.desktop.screensaver picture-uri)
if [ "$CURRENT_FONT" != "'file://$USER_HOME/Pictures/RS_Siege1.jpg'" ]; then
    wget -qO -P "$USER_HOME/Pictures/" https://github.com/MichielVanderlee/system_config/raw/master/assets/wallpapers/RS_Siege1.jpg

    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Humanity-Dark"
    gsettings set org.gnome.desktop.background picture-uri "file://$USER_HOME/Pictures/RS_Siege1.jpg"
    gsettings set org.gnome.desktop.screensaver picture-uri "file://$USER_HOME/Pictures/RS_Siege1.jpg"
fi

# Install fonts
CURRENT_FONT=$(gsettings get org.gnome.desktop.interface monospace-font-name)
if [ "$CURRENT_FONT" != "'FuraCode Nerd Font 11'" ]; then
	echo "Install Fonts"
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
echo "Setting Terminal Theme"
wget -qO terminal.profile https://github.com/MichielVanderlee/system_config/raw/master/terminal.profile
cat terminal.profile | dconf load /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ -


# NVM
if [[ ! -d "$USER_HOME/.nvm" ]]; then
	echo "Installing NVM"
	wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.35.2/install.sh | bash
fi

# PyEnv
if [[ ! -d "$USER_HOME/.pyenv" ]]; then
	echo "Installing pyenv"
	git clone https://github.com/pyenv/pyenv.git $USER_HOME/.pyenv

    if [ -n "$SUDO_USER" ]; then 
        chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.pyenv
    fi
fi
if [[ ! -d "$USER_HOME/.pyenv/plugins/pyenv-virtualenv" ]]; then
	echo "Installing pyenv-virtualenv"
	git clone https://github.com/pyenv/pyenv-virtualenv.git $USER_HOME/.pyenv/plugins/pyenv-virtualenv
fi
if [[ ! -d "$USER_HOME/.pyenv/plugins/pyenv-install-latest" ]]; then
	echo "Installing pyenv-install-latest"
    git clone https://github.com/momo-lab/pyenv-install-latest.git $USER_HOME/.pyenv/plugins/pyenv-install-latest
fi
if [ -z ${PYENV_ROOT+x} ]; then
    echo "Adding pyenv to shell session"
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi

    if [ -f "$PYENV_ROOT/versions/$(cat $PYENV_ROOT/version)/bin/aws_zsh_completer.sh" ]; then
        source "$PYENV_ROOT/versions/$(cat $PYENV_ROOT/version)/bin/aws_zsh_completer.sh"
    fi

    echo "Installing latest python"
    pyenv install-latest
    # Set latest version as global
    pyenv global "$(pyenv install-latest --print)"
fi


# GoEnv
if [[ ! -d "$USER_HOME/.goenv" ]]; then
	echo "Installing goenv"
	git clone https://github.com/syndbg/goenv.git $USER_HOME/.goenv
    
    if [ -n "$SUDO_USER" ]; then 
        chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.goenv
    fi
fi

# RbEnv
if [[ ! -d "$USER_HOME/.rbenv" ]]; then
	echo "Installing rbenv"
	git clone https://github.com/rbenv/rbenv.git $USER_HOME/.rbenv
    mdkir -p $USER_HOME/.rbenv/plugins
    git clone https://github.com/rbenv/ruby-build.git $USER_HOME/.rbenv/plugins/ruby-build
    if [ -n "$SUDO_USER" ]; then 
        chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.rbenv
    fi

    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    rbenv install $(rbenv install -l | grep -v - | tail -1)
    rbenv global $(rbenv install -l | grep -v - | tail -1)
fi

# extra packages

# For RedHat/CentOS
if [ "$(command -v yum)" ]; then
	yum makecache fast
	yum install -y \
        zlib \
        zlib-devel \
        readline \
        readline-devel \
        bzip2 \
        bzip2-devel \
        sqlite-devel \
        openssl-devel \
        patch \
        htop
fi
# Ubuntu (force-yes for bash on windows)
if [ "$(command -v apt-get)" ]; then
	apt-get install -y --force-yes \
		zlibc \
        zlib1g \
        zlib1g-dev \
        libreadline7 \
        libreadline-dev \
        libbz2-dev \
		libpq-dev \
        libsqlite3-dev \
        openssl \
        libssl-dev \
        postgresql-client \
        htop \
        ssh
else
	echo "No suitable package manager found. (yum, apt-get)"
	exit 127
fi

pip install awscli


# pgcli
pip install pgcli

if [[ ! -d "$USER_HOME/.psql-pager" ]]; then
    echo "Installing pgcli pager"
    git clone https://github.com/mvanderlee/psql-pager.git $USER_HOME/.psql-pager
    cd $USER_HOME/.psql-pager
    python3 ./install.py
    cd -
fi

# ptpython
if [[ ! -d "$USER_HOME/.ptpython" ]]; then
    echo "Installing ptpython"
    pip install ptpython
    mkdir $USER_HOME/.ptpython
    wget -O $USER_HOME/.ptpython/config.py https://github.com/MichielVanderlee/system_config/raw/master/.ptpython-config.py
    if [ -n "$SUDO_USER" ]; then 
        chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.ptpython
    fi
fi

# colorls
echo "Installing ptpython"
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
