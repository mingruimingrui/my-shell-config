#!/bin/sh
set -e

# Download starship
if ! command -v starship > /dev/null; then
  echo "Installing starship into ~/.local/bin"
  curl -fsSL -o install.sh https://starship.rs/install.sh
  mkdir -p ~/.local/bin
  sh install.sh -b ~/.local/bin -f
  rm install.sh
fi

# Download repository
REPO_DIR=~/.my-shell-config
if [ ! -d $REPO_DIR ]; then
  echo "Downloading my-shell-config"
  git clone git@github.com:mingruimingrui/my-shell-config.git $REPO_DIR || \
  git clone https://github.com/mingruimingrui/my-shell-config.git $REPO_DIR
fi
cd $REPO_DIR

# Symlink/copy files over
mkdir -p ~/.config/fish ~/.config/nvim
cp $REPO_DIR/config.fish ~/.config/fish/config.fish  # config.fish is a stub
ln -sf $REPO_DIR/custom.fish ~/.config/fish/custom.fish
ln -sf $REPO_DIR/init.vim ~/.config/nvim/init.vim

# Run conda init to modify config.fish
if [ -d ~/miniconda3/bin ]; then
  echo "Running conda init"
  ~/miniconda3/bin/conda init fish
fi

# Install neovim packages
if command -v nvim > /dev/null; then
  echo "Installing neovim plugins"
  nvim +PlugClean +PlugUpgrade +PlugUpdate +qall | true
  nvim +GoUpdateBinaries +qall | true
fi

# Reminder to install fish
if ! command -v fish > /dev/null; then
  echo "Remember to install fish later!"
fi
