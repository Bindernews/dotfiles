# Overview
These are my config files for bash/zsh/vim/nvim/etc. Much of it is customized
for my uses specifically.

From here on out `$DOTFILES` will refer to the directory in which the dotfiles
repo resides. In fact shell profile MUST set `DOTFILES` in order to use the scripts.

Example `.zshrc`
```sh
export DOTFILES=$HOME/dotfiles
source $DOTFILES/geode/zshrc
```

# Vim and Neovim
While I don't use vim as my primary editor, I'm familiar with it and it's my
go-to for ssh and terminal environments (generally I use VS Code). My neovim
config is what I'll be updating going forwards, but I'm leaving the `vimrc`
here as a fallback in case I'm on a system with vim but without neovim.

To use my neovim config `source $DOTFILES/common.sh` in your shell profile
and call `setup_aliases`. That will create an `nvim` alias.

To use the vim config simply put `source $DOTFILES/vimrc` in your `.vimrc`.

