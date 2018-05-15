#!/bin/sh

# Welcome to the civil laptop script!
# Be prepared to turn your laptop (or desktop, no haters here)
# into an awesome development machine.

fancy_echo() {
  local fmt="$1"; shift

  printf "\n$fmt\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'


update_shell() {
  local shell_path;
  shell_path="$(which zsh)"

  fancy_echo "Changing your shell to zsh ..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    fancy_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  sudo chsh -s "$shell_path" "$USER"
}

case "$SHELL" in
  */zsh)
    if [ "$(which zsh)" != '/usr/local/bin/zsh' ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
    rbenv rehash
  fi
}

if ! [ -f "$HOME/.gitconfig" ]; then
    echo "
[alias]
co = checkout
st = status
ci = commit
cis = commit -S
df = diff
dfc = diff --cached
quick-amend = amend --no-edit
[push]
default = current " >> ~/.gitconfig
fi

# Install tooling
sudo yum install zsh python unzip build-essential auto-conf libncurses5-dev libssh-dev unixodbc-dev m4 inotify-tools


# ASDF - version manager

if ! [ -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3

  append_to_zshrc ". $HOME/.asdf/asdf.sh"
  append_to_zshrc ". $HOME/.asdf/completions/asdf.bash"
fi

# Ensure ADSF is loaded
source "$HOME/.asdf/asdf.sh"

# Install Ruby

if ! [ -d "$HOME/.asdf/plugins/ruby" ]; then
  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
  LDFLAGS="-L/usr/local/opt/openssl/lib" CPPFLAGS="-I/usr/local/opt/openssl/include" asdf install ruby 2.3.3
  asdf global ruby 2.3.3
fi

# Install Erlang

if ! [ -d "$HOME/.asdf/plugins/erlang" ]; then
  asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
  asdf install erlang 20.3
  asdf global erlang 20.3
fi

# Install Elixir

if ! [ -d "$HOME/.asdf/plugins/elixir" ]; then
  asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
  asdf install elixir 1.6.4
  asdf global elixir 1.6.4
fi

# Install NodeJS

if ! [ -d "$HOME/.asdf/plugins/nodejs" ]; then
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  # Imports Node.js release team's OpenPGP keys to main keyring
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
  asdf install nodejs 7.4.0
  asdf global nodejs 7.4.0
fi


if ! [ -d "$HOME/.asdf/plugins/golang" ]; then
    asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
    asdf install golang 1.9
    asdf global golang 1.9
fi

if [ -f "$HOME/.laptop.local" ]; then
  fancy_echo "Running your customizations from ~/.laptop.local ..."
  . "$HOME/.laptop.local"
fi

if [ ! -d "$HOME/.oh-my-zsh/" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Setup common config for .zsh_civilcode

if ! grep --quiet "source $HOME/.civilcode.zshrc" $HOME/.zshrc;  then
    append_to_zshrc '[[ -f ~/.civilcode.zshrc ]] && source $HOME/.civilcode.zshrc'
fi

# Cache git credentials for a minute
git config --global credential.helper 'cache --timeout=3600'

# Install hub
go get github.com/github/hub
sudo cp ~/.golang/bin/hub /usr/local/bin
