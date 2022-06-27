# This file holds common code for various prompts, it should be "sourced`
# not run in a separate shell.
# It should run in bash, zsh, and maybe eventually nushell?
# 

if [ -z "$DOTFILES" ]; then
  echo "ERROR: DOTFILES must be defined" >&2
  return 0
fi

# Could use this to auto-set DOTFILES location
# if [ -n "$ZSH_VERSION" ]; then
#     echo "${(%):-%x}"
# elif [ -n "$BASH_VERSION" ]; then
#     echo "$BASH_SOURCE"
# else
#     echo "ERROR: Cannot determine path to common.sh" >&2
# fi

export SHELL_BASENAME=$(basename "$SHELL")

# Profiling helper function
profileit () {
    if [ -n "$PROFILE_STARTUP" ]; then
        time ($*)
    fi
    eval "$*"
}

#############
# SSH Agent #
#############

# Test to see if an SSH agent is available at the given socket
ssh_test_agent() {
  SSH_AUTH_SOCK=$1 ssh-add -l 2>/dev/null >/dev/null
  local result=$?
  test "$result" == "0" -o "$result" == "1"
  return $?
}

# Make sure we have an SSH agent available
ensure_ssh_agent() {
  ssh_test_agent "$SSH_AUTH_SOCK"
  if [ $? -eq 1 ]; then
    local SOCKET="$HOME/.ssh/agent-socket"
    mkdir -p $HOME/.ssh
    ssh_test_agent "$SOCKET"
    if [ ! $? ]; then
      eval $(ssh-agent -a "$SOCKET")
    else
      export SSH_AUTH_SOCK="$SOCKET"
    fi
  fi
}

ssh_add_keys() {
  local key_ids=$(ssh-add -l | awk '{print $3}')
  while [ "$1" != "" ]; do
    # We're adding the private key, but we test the public key identity
    local test_id=$(cat "$1.pub" | awk '{print $3}')
    local should_add=true
    for kp in $key_ids; do
      if [ "$1" = "$kp" ] || [ "$test_id" = "$kp" ]; then 
        should_add=false
      fi
    done
    if $should_add; then
      ssh-add "$1"
    fi
    shift
  done
}

##########
# Colors #
##########

# Exit true if terminal supports color, false if not.
# Set CLICOLOR to automatically return true.
has_color () {
    if [ -n "$CLICOLOR" ]; then
        return 0;
    fi
    # If the terminal is xterm or has the name -256color then assume it has color
    case "$TERM" in
        xterm-color|*-256color) return 0;;
    esac
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        return 0;
    fi
    return 1;
}

# Setup the terminal as 
setup_colors () {
    if [ ! has_color ]; then
        return
    fi

    # This exports LS_COLORS if dircolors exists, which changes what colors LS uses.
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    fi

    export CLICOLOR=true
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

# Helper to reset IFS to default value
reset_ifs () {
  export IFS=$' \t\n'
}

setup_aliases () {
    # Select editor, lowest-to-highest priority
    for e in "nano" "vim" "nvim"; do
        if which $e >/dev/null; then export EDITOR=$e; fi
    done
    export VISUAL=$EDITOR
    # Add extra ls aliases
    alias ll='ls -l'
    alias la='ls -Al'
    alias l='ls -CF'
    # Use nvim config in dotfiles
    alias nvim='XDG_CONFIG_HOME=$DOTFILES nvim'
    alias nvim-raw='/usr/local/bin/nvim'
}


# Activate the Python venv in directory $1
workon () {
  for path in "$1" "$HOME/.virtualenv/$1"; do
    if [ -f "$path/bin/activate" ]; then
      source "$path/bin/activate"
      return $?
    fi
  done
  echo "Directory is not a Python venv"
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

# Removes all duplicate path entries, preserving the order
setup_dedup_path () {
  export PATH=$(awk '{
    mx=split($0,a,":"); sep="";
    for (i=1; i<=mx; i++) { if (!seen[a[i]]++) printf sep a[i]; sep=":" }
    print ""
  }' <<< $PATH)
}


