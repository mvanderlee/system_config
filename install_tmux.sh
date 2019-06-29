#!/bin/bash

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
		wget \
		vim \
		build-essential \
		linux-headers-generic \
		libncurses5-dev \
		xdg-utils
else
	echo "No suitable package manager found. (yum, apt-get)"
	exit 127
fi

# DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
tar -xzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=/usr/local
make
sudo make install
cd
rm -rf libevent-2.1.8-stable*

# DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
wget https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5.tar.gz
tar -xzf tmux-2.5.tar.gz
cd tmux-2.5
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
make
sudo make install
cd
rm -rf tmux-2.5*

USER_HOME=$(if [ -e $SUDO_USER ]; then echo $HOME; else getent passwd $SUDO_USER | cut -d: -f6; fi)

git clone https://github.com/tmux-plugins/tpm $USER_HOME/.tmux/plugins/tpm

wget https://github.com/MichielVanderlee/system_config/raw/master/.tmux.conf -O $USER_HOME/.tmux.conf

if [ -n "$SUDO_USER" ]; then 
	chown $SUDO_USER:$SUDO_USER $USER_HOME/.tmux.conf
	chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.tmux
fi

echo "Open TMUX and press 'ctrl+a shift+i'. Ensure you're not nested in screen!'"
