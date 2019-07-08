#!/bin/bash

# This file is setup as a series of functions. It defines a few functions when source'd, but doesn't
# change anything else. To use it, source it and then run the following:
# 
# setup_shell
# if has_color; then setup_colors; fi
# setup_aliases
# 

##############################
# Shell and Terminal Options #
##############################

setup_shell () {
    # don't put duplicate lines or lines starting with space in the history.
    # See bash(1) for more options
    HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # If set, the pattern "**" used in a pathname expansion context will
    # match all files and zero or more directories and subdirectories.
    shopt -s globstar
}

setup_xterm () {
    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
    esac
}

#############
# SSH Agent #
#############

# Make sure we have an SSH agent available
test_agent_socket () {
  SSH_AUTH_SOCK=$1 ssh-add -l 2>/dev/null >/dev/null
  local result=$?
  return [[ $result -eq 0 -p $result -eq $1 ]]
}

#ensure_ssh_agent() {
#  if [ ! test_agent_socket "$SSH_AUTH_SOCK" ]; then
#    local SOCKET=$HOME/.ssh/agent-socket
#    mkdir -p $HOME/.ssh
#    if [ ! test_agent_socket "$SOCKET" ]; then
#      eval $(ssh-agent -a "$SOCKET") >/dev/null
#    fi
#  fi
#  ssh-add -l >/dev/null
#}
#ensure_ssh_agent

##########
# Colors #
##########

# Echos "yes" if the terminal supports color, "" if it doesn't.
has_color () {
    # If the terminal is xterm or has the name -256color then assume it has color
    case "$TERM" in
        xterm-color|*-256color) echo "yes"; return 0;;
    esac
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        echo "yes"; return 0;
    fi
    return 1;
}

setup_colors () {
    # This exports LS_COLORS if dircolors exists, which changes what colors LS uses.
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    fi

    export CLICOLOR=y
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # colored GCC warnings and errors. Copied from Ubuntu bashrc.
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
}

#########################
# Aliases and Functions #
#########################

setup_aliases () {
    if [ -f "/usr/bin/vim" ]; then
        export VISUAL=vim
        export EDITOR=vim
    fi
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
}

# Activate the Python venv in directory $1
workon () {
  if [ -f "$1/bin/activate" ]; then
    source "$1/bin/activate"
  else
    echo "Directory is not a Python venv"
  fi
}

# Run vim and enable loading the .vimrc file in the cwd
# This works in conjunction with my vimrc file.
lvim () {
  if [ "$PWD" != "$HOME" ]; then
    VIM_LOCAL=y vim $*
  else
    vim $*
  fi
}

# Utility function for adding directories to the path
add_path () {
    local opt_prefix=false
    while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
        -p | --prefix )
            opt_prefix=true
            ;;
    esac; shift; done
    if [ -d "$1" ]; then
        if $opt_prefix; then
            export PATH="$1:$PATH"
        else
            export PATH="$PATH:$1"
        fi
    fi
}

