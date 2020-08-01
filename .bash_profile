if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

export PATH="${PATH}:$HOME/.scripts"
export WALLPAPERS=$HOME/Pictures/Wallpapers

# Android building
export PATH=$HOME/.local/platform-tools:$PATH
export PATH=$HOME/.local/bin:$PATH

# Default editor for $USER
export EDITOR=/usr/bin/nvim
