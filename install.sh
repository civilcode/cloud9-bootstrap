#!/bin/sh

# setup `Development` directory
if ! [ -d "$HOME/Development" ]; then
 mkdir -p ~/Development
fi

# dotfiles
if ! [ -d "$HOME/Development/dotfiles" ]; then
  cd ~/Development && \
    git clone https://github.com/civilcode/dotfiles.git
else
  cd ~/Development/dotfiles && \
   git pull --force
fi

# rcm
if [ "$(which rcup)" != '/usr/local/bin/rcup' ] ; then
  cd ~/Development && \
    curl -LO https://thoughtbot.github.io/rcm/dist/rcm-1.3.3.tar.gz && \
      tar -xvf rcm-1.3.3.tar.gz && \
      cd rcm-1.3.3 && \
      ./configure && \
      make && \
      sudo make install
fi

# docker-compose
if [ "$(which docker-compose)" != '/usr/local/bin/docker-compose' ] ; then
  cd ~/Development && \
    sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
fi

# hub
if [ "$(which hub)" != '/usr/local/bin/hub' ] ; then
 cd ~/Development && \
   wget https://github.com/github/hub/releases/download/v2.5.0/hub-linux-386-2.5.0.tgz && \
     tar zvxvf hub-linux-386-2.5.0.tgz && \
     sudo ./hub-linux-386-2.5.0/install && \
     rm -rf ./hub-linux-386-2.5.0 && \
     rm -rf ./hub-linux-386-2.5.0.tgz
fi

# direnv
if [ "$(which direnv)" != '/usr/local/bin/direnv' ] ; then
  cd ~/Development && \
    git clone http://github.com/direnv/direnv.git && \
     cd direnv && \
     make && \
     sudo make install
fi

# setup
env RCRC=$HOME/Development/dotfiles/rcrc rcup -f && lsrc

if ! [ -f "$HOME/.tmux.conf" ]; then
  curl -L https://raw.githubusercontent.com/civilcode/cloud9-bootstrap/master/tmux.conf  -o ~/.tmux.conf
fi

if ! grep --quiet "source $HOME/.civilcode.shrc" $HOME/.bashrc;  then
  echo "source $HOME/.civilcode.shrc" >> ~/.bashrc
fi

if ! grep --quiet "eval \"$(direnv hook bash)\"" $HOME/.shrc.local;  then
  echo 'eval "$(direnv hook bash)"' >> ~/.shrc.local
fi

echo "Finished. Run 'source ~/.bashrc'."
