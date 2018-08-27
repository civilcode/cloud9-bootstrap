#!/bin/sh

# docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# dotfiles
mkdir -p ~/Development \
    && cd ~/Development \
    && git clone https://github.com/civilcode/dotfiles.git \
    && env RCRC=$HOME/Development/dotfiles/rcrc rcup \
    && lsrc

# rcm
curl -LO https://thoughtbot.github.io/rcm/dist/rcm-1.3.3.tar.gz \
  && tar -xvf rcm-1.3.3.tar.gz \
  && cd rcm-1.3.3 \
  && ./configure \
  && make \
  && sudo make install

# hub
wget https://github.com/github/hub/releases/download/v2.5.0/hub-linux-386-2.5.0.tgz \
  && tar zvxvf hub-linux-386-2.5.0.tgz \
  && sudo ./hub-linux-386-2.5.0/install \
  && rm -rf ./hub-linux-386-2.5.0 \
  && rm -rf ./hub-linux-386-2.5.0.tgz

# setup
echo "source $HOME/.civilcode.zshrc" >> ~/.bashrc
env RCRC=$HOME/Development/dotfiles/rcrc rcup -f
source ~/.bashrc
