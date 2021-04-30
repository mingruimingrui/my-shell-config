#!/bin/sh
set -e

# Download starship
if ! command -v starship > /dev/null; then
	echo "Installing starship into $HOME/.local/bin"
	curl -fsSL -o install.sh https://starship.rs/install.sh
	mkdir -p $HOME/.local/bin
	sh install.sh -b $HOME/.local/bin -f
	rm install.sh
fi

# Download repository
REPO_DIR=$HOME/.my-shell-config
if [ ! -d "$REPO_DIR" ]; then
	echo "Downloading my-shell-config"
	REPO_URL=https://github.com/mingruimingrui/my-shell-config.git
	if [ ! -z "$USE_SSH" ]; then
		REPO_URL=git@github.com:mingruimingrui/my-shell-config.git
	fi
	git clone $REPO_URL $REPO_DIR
fi
cd $REPO_DIR

# Symlink files over
echo "Linking configs"
mkdir -p $HOME/.config/fish
cp $REPO_DIR/config.fish $HOME/.config/fish/config.fish  # config.fish is a stub
ln -sf $REPO_DIR/custom.fish $HOME/.config/fish/custom.fish

mkdir -p $HOME/.config/nvim
ln -sf $REPO_DIR/init.vim $HOME/.config/nvim/init.vim

# Run conda init to modify config.fish
if [ -d "$HOME/miniconda3/bin" ]; then
	$HOME/miniconda3/bin/conda init fish
fi

# Install neovim packages
if command -v nvim > /dev/null; then
	nvim +PlugClean +PlugUpgrade +PlugUpdate +qall | true
	nvim +GoUpdateBinaries +qall | true
fi

# Reminder to install fish
if ! command -v fish > /dev/null; then
	echo "Remember to install fish later!"
fi
