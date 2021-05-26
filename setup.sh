#!/usr/bin/env bash

## FOR SPIN ENVIRONMENT ##
if [ $SPIN ]; then
  # move files from ~/dotfiles
  echo "Moving files..."
  ln -sf ~/dotfiles/.vimrc ~/.vimrc
  ln -sf ~/dotfiles/.vim ~/.vim
  ln -sf ~/dotfiles/.zshrc ~/.zshrc

  # install packages
  if ! command -v fzf &> /dev/null; then
    echo "Installing FZF..."
    sudo apt-get install -y fzf
  fi
fi

# Run VimPlug
echo "Running VimPlug..."
vim +PlugInstall +qa!
