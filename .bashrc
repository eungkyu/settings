# interactive shell인 경우에만 진행
[ "$PS1" ] || return

# default settings
USE_DARK_BACKGROUND=no
USE_SCREEN=no
USE_SSH_AGENT=no

# local settings
if [ -e ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

export USE_DARK_BACKGROUND
export USE_SCREEN
export USE_SSH_AGENT

noop () {
    echo -n
}

# reset PROMPT_COMMAND
PROMPT_COMMAND=noop

# use screen
if [ -e ~/.bashrc.screen ]; then
	source ~/.bashrc.screen
fi

# load ssh-agent
if [ -e ~/.bashrc.ssh-agent ]; then
	source ~/.bashrc.ssh-agent
fi

# empty title before ssh if in apple terminal
if [ "$TERM_PROGRAM" = Apple_Terminal ]; then
    alias ssh='echo -ne "\033]0;\007" && ssh'
fi

# git auto-completion
if [ -e /etc/bash_completion.d/git ]; then
	source /etc/bash_completion.d/git
elif [ -e /usr/local/git/contrib/completion/git-completion.bash ]; then
	source /usr/local/git/contrib/completion/git-completion.bash
fi

# check the terminal size when bash regains control
shopt -s checkwinsize

# user mask
umask 022

# user limit
ulimit -c 0

# default programs
export VISUAL=vim
export EDITOR="$VISUAL"
export GREP_OPTIONS='--color=auto --exclude=cscope.*'
export CLICOLOR=

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

case "$(uname -s)" in
	FreeBSD | Darwin)
        alias ls='ls -v'
        ;;
	Linux | CYGWIN*)
        alias ls='ls -N --color=auto'
        ;;
esac

alias grep='grep --color=auto'
alias less='less -r'
alias vim='vim -p'
alias g='git'
alias ggrep='git grep'

if type git >/dev/null; then
	alias diff='git diff --no-index'
fi

sgrep () {
	if [ $# -eq 0 ]; then
		grep -rI
	elif [ $# -eq 1 ]; then
		grep -rI "$1" *
	else
		grep -rI "$@"
	fi
}

ffind () {
    if [ $# -eq 0 ]; then
        find . -type f
        return
    fi

    cond=(-name "*$1*")
    shift

    while [ "$1" ]; do
        cond=("${cond[@]}" -o -name "*$1*")
        shift
    done
    echo find . -type f "(" "${cond[@]}" ")"
    find . -type f "(" "${cond[@]}" ")"
}

alias cd='cd_helper'
alias vi='vi_helper'

cd_helper () {
	if [ $# -eq 0 ]; then
		\cd
	elif [ -f "$1" ]; then
		vim -p "$@"
	else
		\cd "$@"
	fi
}

vi_helper () {
	if [ $# -eq 0 ]; then
		vim
	elif [ -d "$1" ]; then
		\cd "$@"
	else
		vim -p "$@"
	fi
}

# Add android sdk path
if [ -d "$ANDROID_HOME" ]; then
    PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
fi

if [ -e ~/.bashrc.prompt ]; then
	source ~/.bashrc.prompt
fi

show_color_table () {
    printf "   foreground color table over white background\n\n"
    for c in $(seq 0 255); do
        if [ $(( $c % 16 )) -eq 0 ]; then
            printf "\e[48;5;231m"
        fi

        printf "\e[38;5;%dm%4d" $c $c

        if [ $(( $c % 16 )) -eq 15 ]; then
            printf "\e[0m\n"
        fi
    done
    printf "\n"

    printf "   foreground color table over black background\n\n"
    for c in $(seq 0 255); do
        if [ $(( $c % 16 )) -eq 0 ]; then
            printf "\e[48;5;0m"
        fi

        printf "\e[38;5;%dm%4d" $c $c

        if [ $(( $c % 16 )) -eq 15 ]; then
            printf "\e[0m\n"
        fi
    done
    printf "\n"

    printf "   background color table on black foreground\n\n"
    for c in $(seq 0 255); do
        if [ $(( $c % 16 )) -eq 0 ]; then
            printf "\e[38;5;0"
        fi

        printf "\e[48;5;%dm%4d" $c $c

        if [ $(( $c % 16 )) -eq 15 ]; then
            printf "\e[0m\n"
        fi
    done
    printf "\n"

    printf "   background color table on white foreground\n\n"
    for c in $(seq 0 255); do
        if [ $(( $c % 16 )) -eq 0 ]; then
            printf "\e[38;5;231m"
        fi

        printf "\e[48;5;%dm%4d" $c $c

        if [ $(( $c % 16 )) -eq 15 ]; then
            printf "\e[0m\n"
        fi
    done
    printf "\e[0m"
}
