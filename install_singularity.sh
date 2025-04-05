#!/bin/bash

# Define versions
INSTALL_DIR="/usr/local"
GO_VERSION="1.14.12"
SING_VERSION="3.7.4"
OS="linux"
ARCH="amd64"   # use amd64 inside Vagrant (x86_64), not arm64

# Setup environment
cd $HOME

# Install pre-requisites
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    cryptsetup curl

# Install Go
if [ ! -f "go$GO_VERSION.$OS-$ARCH.tar.gz" ]; then
  wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz
fi
sudo tar -C $INSTALL_DIR -xzf go$GO_VERSION.$OS-$ARCH.tar.gz
export PATH="/usr/local/go/bin:$PATH"
echo "export PATH=/usr/local/go/bin:\$PATH" >> ~/.bashrc

# Install Singularity
if [ ! -f "singularity-$SING_VERSION.tar.gz" ]; then
  wget https://github.com/hpcng/singularity/releases/download/v$SING_VERSION/singularity-$SING_VERSION.tar.gz
fi
tar -xzf singularity-$SING_VERSION.tar.gz
cd singularity

./mconfig --prefix=$INSTALL_DIR
make -C ./builddir
sudo make -C ./builddir install

cd ..
rm -rf singularity

# Optional: turn off home mount (can break some clusters)
sudo sed -i 's/^ *mount *home *=.*/mount home = no/g' $INSTALL_DIR/etc/singularity/singularity.conf

# Enable Singularity bash completion
echo ". $INSTALL_DIR/etc/bash_completion.d/singularity" >> ~/.bashrc

# Confirm install
echo "✅ Singularity installation complete!"
singularity --version

