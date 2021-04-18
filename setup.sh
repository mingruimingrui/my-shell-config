#!/bin/sh
set -e

# Ensure that required softwares are downloaded
if ! command -v fish > /dev/null; then
	echo "fish is required"
	exit 1
fi

# starship
if ! command -v starship > /dev/null; then
	echo "Installing starship into ~/.local/bin"
	curl -fsSL -o install.sh https://starship.rs/install.sh
	mkdir -p ~/.local/bin
	sh install.sh -b ~/.local/bin/starship
	rm install.sh
fi

# Download repository
REPO_DIR=~/.my-shell-config
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
mkdir -p ~/.config/fish
cp $REPO_DIR/config.fish ~/.config/fish/config.fish  # config.fish is a stub
ln -sf $REPO_DIR/custom.fish ~/.config/fish/custom.fish

mkdir -p ~/.config/nvim
ln -sf $REPO_DIR/init.vim ~/.config/nvim/init.vim

# Run conda init to modify config.fish
if [ -d "~/miniconda3/bin" ]; then
	~/miniconda3/bin/conda init fish
fi

# Install neovim packages
if command -v nvim > /dev/null; then
	nvim +PlugClean +PlugUpgrade +PlugUpdate +qall
	nvim +GoUpdateBinaries +qall
fi
