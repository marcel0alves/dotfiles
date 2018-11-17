# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
#
#

# Add local 'pip' to PATH:
export PATH="${PATH}:${HOME}/.local/bin/"

# Import colorscheme from 'wal' asynchronously
(cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

# Default editor for $USER
export EDITOR=${EDITOR:-/usr/bin/vim}

# Fix cedilha character
export LC_CTYPE=pt_BR.utf8

# Aliases

# Emerge functions
alias updatesystem="sudo emerge --sync && sudo emerge -auvND @world"
alias cleanemerge="sudo emerge --ask --depclean"
alias searchpkg="emerge -s"
alias installpkg="sudo emerge --ask"
alias removepkg="sudo emerge --ask --unmerge"
alias emergeworld="sudo emerge -auvND @world"

# Portage files
alias make.conf="sudo vim /etc/portage/make.conf"
alias package.use="sudo vim /etc/portage/package.use"

# Bspwm config
alias bspconfig="vim ~/.config/bspwm/bspwmrc"

# Polybar config
alias barconfig="vim ~/.config/polybar/config"

# Minimalist scheme
alias minimalist="wal -i ~/Pics/Minimalist/"

# Synthwave scheme
alias synthwave="wal -i ~/Pics/Synthwave/"

# Abstract scheme
alias abstract="wal -i ~/Pics/Abstract/"

# ls
alias ls="ls -l"
alias la="ls -la"

# Start X
alias startx="startx -- vt1"

# Bspwm config
alias bspconfig="vim .config/bspwm/bspwmrc"

#
# Functions
#
# Show how much RAM application uses
ram () {
	local sum
	local items
	local app="$1"
	if [ -z "$app" ] ; then
		echo "First argument - pattern to grep from process"
	else
		sum=0
		for i in `ps aux | grep -i "$app" | grep -v "grep" | awk '{print $6}'`; do
			sum=$(($i + $sum))
		done
		
		sum=$(echo "scale=2; $sum / 1024.0" | bc)
		if [[ $sum != "0" ]]; then
			echo "${fg[blue]}${app}${reset_color} uses ${fg[green]}${sum}${reset_color} MBs of RAM."
		else
			echo "There are no processes with pattern '${fg[blue]}${app}${reset_color}' are running."
		fi
	fi
}
