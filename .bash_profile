# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

# Starting devmon in daemon mode
devmon 2>&1 > /dev/null &

# Start MPD daemon
mpd &
