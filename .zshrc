#
# Functions
#

function _zshrc_ssh_agent_exit() {
	ssh-agent -k > /dev/null 2>&1
	rm -f "$SSH_ENV"
}

function _zshrc_ssh_agent_start() {
	if ssh-agent | grep -v '^echo' > "$SSH_ENV"; then
		chmod 600 $SSH_ENV
		. "$SSH_ENV" > /dev/null 2>&1

		if ssh-add > /dev/null 2>&1; then
			return
		fi
	fi

	_zshrc_ssh_agent_exit
}

function _zshrc_ssh_wrapper() {
	cmd=$1; shift

	if [ -r "$SSH_ENV" ]; then
		. "$SSH_ENV" > /dev/null 2>&1
		pgrep ssh-agent | grep -q $SSH_AGENT_PID || _zshrc_ssh_agent_start
	else
		_zshrc_ssh_agent_start
	fi 

	case $cmd in
		ssh|scp|sftp) (unfunction $cmd; $cmd $@);;
	esac
}

function ssh  { _zshrc_ssh_wrapper $0 $@ }
function scp  { _zshrc_ssh_wrapper $0 $@ }
function sftp { _zshrc_ssh_wrapper $0 $@ }

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
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.mkv=01;35:*.wmv=01;35:*.ogm=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
export PATH="$HOME/bin:$PATH:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin"
export SSH_ENV="$HOME/.ssh/agent_environment"
export MYSQL_HISTFILE=/dev/null

unset HISTFILE

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

# 
# Host based configuration
#

case "$(hostname | sed 's/\([^\.]*\)\..*/\1/')" in
	xevz)
		#
		# Alias
		#

		#
		# Hashes
		#

		;;

	laptop)
		#
		# Hashes
		#

		;;
esac

if [ -r "$SSH_ENV" ]; then
	source "$SSH_ENV"
fi

