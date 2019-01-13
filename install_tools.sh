#!/bin/bash

# Set theme
wget -P "$HOME/Pictures/" https://github.com/MichielVanderlee/system_config/raw/master/assets/wallpapers/RS_Siege1.jpg

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface icon-theme "Humanity-Dark"
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/RS_Siege1.jpg"
gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/Pictures/RS_Siege1.jpg"

# Install fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip
mkdir -p ~/.fonts/truetype/FuraCode
unzip FiraCode.zip -d ~/.fonts/truetype/FuraCode -x '*.otf' '*Windows Compatible.ttf'

# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip
# mkdir -p ~/.fonts/opentype/FuraMono
# unzip FiraMono.zip -d ~/.fonts/opentype/FuraMono -x '*Windows Compatible.otf'

sudo fc-cache -f -v
gsettings set org.gnome.desktop.interface monospace-font-name "FuraCode Nerd Font 11"


# Set Terminal Theme
wget https://github.com/MichielVanderlee/system_config/raw/master/terminal.profile
cat terminal.profile | dconf load /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ -


# NVM
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# PyEnv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv


# extra packages
# Ubuntu (force-yes for bash on windows)
if [ "$(command -v apt-get)" ]; then
	apt-get install -y --force-yes \
		zlibc \
        zlib1g \
        zlib1g-dev \
        libreadline7 \
        libreadline-dev \
        libbz2-dev \
        libsqlite3-dev \
        openssl \
        libssl-dev \
        postgresql-client
else
	echo "No suitable package manager found. (yum, apt-get)"
	exit 127
fi

# pgcli
pip install pgcli

git clone git@github.com:kyokley/vim-psql-pager.git
cd vim-psql-pager
./install.py
cd -
rm -rf vim-psql-pager