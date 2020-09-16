
setopt autocd
autoload -Uz compinit
compinit -u
setopt hist_ignore_all_dups
setopt hist_ignore_space

export PROMPT='%(?.%F{green}√.%F{red}%?)%f %1~ %(!.#.$) '

