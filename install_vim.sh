#!/bin/bash

# For RedHat/CentOS
if [ "$(command -v yum)" ]; then
	yum install -y \
		epel-release \
		yum-utils

	yum makecache fast
	# yum groupinstall -y "Development Tools"
	# https://access.redhat.com/discussions/1262603
	yum group install "Development Tools" --setopt=group_package_types=mandatory,default,optional
	yum install -y \
		wget \
		vim \
		cmake \
		python3-devel \
		python3-pip \
		libffi-devel \
		libcurl-devel \
		openssl-devel \
		socat \
		xorg-x11-server-utils \
		unzip
# Ubuntu (force-yes for bash on windows)
elif [ "$(command -v apt-get)" ]; then
	apt-get install -y --force-yes \
		wget \
		vim \
		build-essential \
		cmake \
		python3-dev \
		python3-pip \
		libffi-dev \
		socat \
		unzip \
		x11-xserver-utils
else
	echo "No suitable package manager found. (yum, apt-get)"
	exit 127
fi


wget https://github.com/libgit2/libgit2/archive/v0.27.0.tar.gz
tar xzf v0.27.0.tar.gz
cd libgit2-0.27.0/
cmake .
make
sudo make install
cd
rm -rf libgit2-0.27.0
rm v0.27.0.tar.gz

wget https://pypi.python.org/packages/3a/6c/52c4ba6050b80e266d87783ccd4d39b76a0d2459965abf1c7bde54dd9a72/python-hglib-2.4.tar.gz#md5=0ef137ffe3239f17484ddb3170b5860e
tar xzf python-hglib-2.4.tar.gz
cd python-hglib-2.4
python3 setup.py install
cd
rm -rf python-hglib-2.4*

# which python3 for ec2 instances where python 2 is the default
$(which python3) -m pip install --upgrade pip
$(which python3) -m pip install \
	psutil \
	pygit2 \
	pyuv \
	i3ipc \
	powerline-status
	
USER_HOME=$(if [ -e $SUDO_USER ]; then echo $HOME; else getent passwd $SUDO_USER | cut -d: -f6; fi)

wget https://github.com/MichielVanderlee/system_config/raw/master/.vimrc -O $USER_HOME/.vimrc
wget https://github.com/MichielVanderlee/system_config/raw/master/vim.zip 
unzip vim.zip -d $USER_HOME
rm vim.zip

if [ -z $SUDO_USER ]; then 
	chown $SUDO_USER:$SUDO_USER $USER_HOME/.vimrc
	chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.vim
fi
