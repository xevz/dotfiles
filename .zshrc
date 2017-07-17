#
# Functions
#

#
# Environment variables
#

if autoload colors zsh/terminfo; then
	if [[ "$terminfo[colors]" -ge 8 ]]; then
		colors
	fi
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
		eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
		eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	done
	PR_NO_COLOR="%{$terminfo[sgr0]%}"
fi

export PS1="[$PR_LIGHT_BLUE%n$PR_NO_COLOR@$PR_LIGHT_MAGENTA%m$PR_NO_COLOR:$PR_LIGHT_GREEN%?$PR_NO_COLOR] "
export RPS1="[$PR_WHITE%~$PR_NO_COLOR]"
export EDITOR=vim
export VISUAL=$EDITOR
export PATH="$HOME/bin:$PATH:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin"
export SSH_ENV="$HOME/.ssh/agent_environment"
export MYSQL_HISTFILE=/dev/null
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

unset HISTFILE

eval $(dircolors --sh)

#
# Aliases
#

alias ls='ls -F --color=auto'
alias l='ls'
alias ll='l -l'
alias la='l -a'
alias blankcd='cdrecord dev=/dev/cdrom blank=fast'
alias burncd='cdrecord dev=/dev/cdrom -overburn -v'

alias unzip_all='for f in *.zip; do dir="$f:r"; [ -d "$dir" ] || unzip -d "$dir" "$f"; done'
alias unrar_all='for f in *.rar; do dir="$f:r"; [ -d "$dir" ] || (mkdir "$dir"; cd "./$dir"; unrar x "../$f"; cd ..); done'

if echo $LANG $LC_ALL $LC_CTYPE | egrep -q 'UTF-?8'; then
	alias man='LC_CTYPE=C man'
fi

#_zshrc_ssh_aliases

#
# Traps
#

trap clear 0

#
# Options
#

setopt AUTO_CD    \
       LIST_TYPES \
       MARK_DIRS  \
	   EXTENDED_GLOB

set -o vi

#
# Completion
#

autoload -U compinit
compinit -u

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format '%BNo match:%b %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s/:/)LS_COLORS}
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:*:kill*:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
zstyle ':completion:*:*:kill*:*' menu yes select
zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'

compdef pkill=killall
compdef skill=killall

#
# Operating system based configuration
#

case "$(uname)" in
	OpenBSD)
		if which gls >/dev/null 2>&1; then
			alias ls="gls -F --color=auto"
		else
			alias ls="ls -F"
		fi

		;;
esac

[ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

