FROM bitwalker/alpine-elixir-phoenix:1.6.5 as builder

# update package manager
RUN apk update \
    apk upgrade --no-cache

# install zsh
RUN apk add --no-cache zsh
RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd
ENV SHELL /bin/zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install development dependencies
RUN apk add --no-cache git

# install hub
RUN apk add --no-cache musl-dev
RUN wget https://github.com/github/hub/releases/download/v2.5.0/hub-linux-386-2.5.0.tgz && \
   tar zvxvf hub-linux-386-2.5.0.tgz && \
   ./hub-linux-386-2.5.0/install && \
   rm -rf ./hub-linux-386-2.5.0 && \
   rm -rf ./hub-linux-386-2.5.0.tgz

# install rcm (dotfiles manager)
RUN curl -LO https://thoughtbot.github.io/rcm/dist/rcm-1.3.3.tar.gz && \
    tar -xvf rcm-1.3.3.tar.gz && \
    cd rcm-1.3.3 && \
    ./configure && \
    make install && \
    cd .. && \
    rm -rf rcm-1.3.3.tar.gz && \
    rm -rf rcm-1.3.3

# install dotfiles
RUN mkdir ~/Development && \
    cd ~/Development && \
    git clone https://github.com/civilcode/dotfiles.git && \
    env RCRC=$HOME/Development/dotfiles/rcrc rcup && \
    lsrc

# add format watcher
RUN cd /usr/local/bin && \
    wget https://raw.githubusercontent.com/civilcode/cloud9-bootstrap/master/format_watcher && \
    chmod +x format_watcher

WORKDIR /app

CMD ["zsh"]
