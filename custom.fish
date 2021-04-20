# Update
if test -d ~/.my-shell-config
	function msc-upgrade -d "Get latest version of my-shell-config"
		cd ~/.my-shell-config
		git pull
	end
end

# Local bin
if test -d ~/.local/bin
	set PATH ~/.local/bin $PATH
	# fish_add_path ~/.local/bin  # I use debian 10 alot at work...
end

if test -d ~/bin
	set PATH ~/bin $PATH
	# fish_add_path ~/bin  # I use debian 10 alot at work...
end

# Neovim
if type -q nvim
	alias vim nvim
	function install-nvim-py-pkgs -d "Install python packages for Neovim"
		pip install --no-cache-dir neovim jedi==0.17.2
	end
end

# Brew
if type -q brew
	function brew-upgrade-clean -d "Update packages and clean up deps"
		brew update
		brew upgrade
		brew missing
		brew doctor
		brew bundle dump
		brew bundle --force cleanup
		brew cleanup
	end
end

# Python
if type -q conda
	function conda-upgrade-base -d "Upgrade base default conda"
		conda update -n base -c defaults conda
	end
end

function pyclean -d "Recursively clean directory from .pyc and .pyo files and python3 __pycache__ folders"
  set -l path2CLEAN

  if set -q $argv
    set path2CLEAN .
  else
    set path2CLEAN $argv
  end

  find $path2CLEAN -type f -name "*.py[co]" -delete -or -type d -name "__pycache__" -delete
end

# Kubernetes
if type -q kubectl
	alias kc kubectl
end

# Go
if test -d ~/.local/go/bin
	set PATH ~/.local/go/bin $PATH
	# fish_add_path ~/.local/go/bin  # I use debian 10 alot at work...
end

if test -d ~/go/bin
	set PATH ~/go/bin $PATH
	# fish_add_path ~/go/bin  # I use debian 10 alot at work...
end

# SSH and rsync
function tunnel -a SERVER PORT -d "SSH port-forwarding shortcut"
	if begin not set -q SERVER[1]; or not set -q PORT[1]; end
		echo "Usage: tunnel SERVER PORT"
		return 1
	end
	ssh -NL "localhost:$PORT":"localhost:$PORT" $SERVER
end

alias rsync "rsync --cvs-exclude --max-size=10m"
function upsync -a SERVER DIRECTORY -d "Shortcut to rsync to server"
	if not set -q SERVER[1]
		echo "Usage: upsync SERVER [DIRECTORY]"
		return 1
	end
	if not set -q DIRECTORY[1]; set DIRECTORY Projects; end
	set NAME (basename $PWD)
	rsync -r $PWD $SERVER:$DIRECTORY
end

# Starship
starship init fish | source

# If in WSL, cd to distro home
if set -q WSL_DISTRO_NAME
	cd ~
end
