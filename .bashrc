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

# Put your fun stuff here

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
	. /usr/share/bash-completion/bash_completion

# Add local 'pip' to PATH:
export PATH="${PATH}:${HOME}/.local/bin"

# Default editor for $USER
# export EDITOR=${EDITOR:-/usr/bin/vim}
export EDITOR=/usr/bin/vim

# Fix Brazil lang
# export LC_CTYPE=pt_BR.utf8

# Aliases

# VDE, QEMU, etc.
alias vde-start="su -c '/home/johnwick/.scripts/vde-network start'"
alias vde-stop="su -c '/home/johnwick/.scripts/vde-network stop'"
alias win10="~/.scripts/win10.sh"
alias win2k16="~/.scripts/win2k16.sh"
alias debian="~/.scripts/debian.sh"

# Ls
alias ll="ls -l --g"
alias la="ls -la --g"

# Emerge functions
alias updatesystem="su -c 'emerge --sync && emerge -auvND @world'"
alias cleanemerge="sudo emerge --ask --depclean"
alias searchpkg="emerge -s"
alias installpkg="sudo emerge -av"
alias removepkg="sudo emerge --ask --unmerge"
alias emergeworld="sudo emerge -auvND @world"

# Portage files
alias make.conf="sudo vim /etc/portage/make.conf"
alias package.use="sudo vim /etc/portage/package.use"
alias package.mask="sudo vim /etc/portage/package.mask"
alias package.accept_keywords="sudo vim /etc/portage/package.accept_keywords"

# Polybar config
alias barconfig="vim ~/.config/polybar/config"

# Bspwm config
alias bspconfig="vim ~/.config/bspwm/bspwmrc"

# Functions

# Run as root
sudo() {
	su -c "$*"
}

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
