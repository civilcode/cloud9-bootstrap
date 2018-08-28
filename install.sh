#!/bin/sh

# setup `Development` directory
 mkdir -p ~/Development

# dotfiles
cd ~/Development && \
  git clone https://github.com/civilcode/dotfiles.git

# rcm
cd ~/Development && \
  curl -LO https://thoughtbot.github.io/rcm/dist/rcm-1.3.3.tar.gz && \
    tar -xvf rcm-1.3.3.tar.gz && \
    cd rcm-1.3.3 && \
    ./configure && \
    make && \
    sudo make install

# docker-compose
cd ~/Development && \
  sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose --version

# hub
cd ~/Development && \
  wget https://github.com/github/hub/releases/download/v2.5.0/hub-linux-386-2.5.0.tgz && \
    tar zvxvf hub-linux-386-2.5.0.tgz && \
    sudo ./hub-linux-386-2.5.0/install && \
    rm -rf ./hub-linux-386-2.5.0 && \
    rm -rf ./hub-linux-386-2.5.0.tgz

# direnv
cd ~/Development && \
  git clone http://github.com/direnv/direnv.git && \
   cd direnv && \
   make && \
   sudo make install

# setup
env RCRC=$HOME/Development/dotfiles/rcrc rcup -f && lsrc
echo "source $HOME/.civilcode.shrc" >> ~/.bashrc
echo 'eval "$(direnv hook bash)"' >> ~/.shrc.local

echo "Finished. Run 'source ~/.bashrc'."
