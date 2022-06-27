
# Common zsh config and prompt
setopt autocd
setopt prompt_subst
autoload -Uz compinit && compinit -u
autoload -U colors && colors
setopt hist_ignore_all_dups
setopt hist_ignore_space

bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Disable posh prompt
unposh () {
    export PROMPT='
    %{$fg[magenta]%}%2~%u %(?.%{$fg[blue]%}.%{$fg[red]%})%(!.#.❯)%{$reset_color%} '
}

eval "$(oh-my-posh init zsh --config "$DOTFILES/oh-my-posh.json")"

