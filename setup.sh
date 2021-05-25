#!/usr/bin/env bash

## FOR SPIN ENVIRONMENT ##
if [ $SPIN ]; then
  # move files from ~/dotfiles
  ln -sf ~/dotfiles/.vimrc ~/.vimrc
  ln -sf ~/dotfiles/.zshrc ~/.zshrc
  ln -sf ~/dotfiles/vim ~/vim

  # install packages
  if ! command -v fzf &> /dev/null; then
    sudo apt-get install -y fzf
  fi
fi

