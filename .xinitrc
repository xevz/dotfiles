#!/bin/bash

export PATH="$HOME/bin:$PATH"

if [[ -x $(which ibus-daemon 2>/dev/null) ]]; then
	export XMODIFIERS=@im=ibus
	export XMODIFIER=@im=ibus
	export GTK_IM_MODULE=ibus

	#ibus-daemon -d
else
	export XMODIFIERS=@im=uim
	export XMODIFIER=@im=uim
	export GTK_IM_MODULE=uim
fi

if [ -x /usr/bin/autocutsel ]; then
    # keep clipboard in sync with primary
    autocutsel -selection CLIPBOARD -fork

    # keep primary in sync with clipboard
    autocutsel -selection PRIMARY -fork
fi

[[ -r $HOME/.Xdefaults ]] && xrdb -merge $HOME/.Xdefaults

setxkbmap se dvorak_a5

[[ -r $HOME/.Xmodmap ]] && xmodmap $HOME/.Xmodmap

xset r rate 185 50
xset b off

xsetroot -solid '#000'

which xbindkeys &>/dev/null && xbindkeys
which start-pulseaudio-x11 &>/dev/null && start-pulseaudio-x11 &
which pasystray &>/dev/null && pasystray &
[[ -r $HOME/.mpdconf ]] && mpd
which redshift-gtk &>/dev/null && redshift-gtk -l 59.523816:17.885369 &
which wicd-client &>/dev/null && wicd-client --tray &
which xsettingsd &>/dev/null && xsettingsd &
which synclient &>/dev/null && synclient TouchpadOff=1

start-stop-daemon --start --make-pidfile --background --pidfile $HOME/.i3/workspace.pid --exec $HOME/.i3/i3workspace.pl

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

exec i3 | tee $HOME/.i3.log

