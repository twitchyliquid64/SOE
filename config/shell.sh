#!/bin/bash

. ~/SOE/util/color.sh

shopt -s promptvars dotglob histappend no_empty_cmd_completion cdspell xpg_echo

export PS1="\[\033[38;5;2m\][\u\[$(tput sgr0)\]\[\033[38;5;1m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h]\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput bold)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]> \[$(tput sgr0)\]"

if [ "$UID" -eq "0" ]; then
  export PS1="\[\033[38;5;2m\][\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;1m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h]\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput bold)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]> \[$(tput sgr0)\]"
fi





# Color prompt
force_color_prompt=yes


alias edit='nano'

export HISTFILESIZE=300000    # save 300000 commands
export HISTCONTROL=ignoredups    # no duplicate lines in the history.
export HISTSIZE=100000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s histappend

alias reload='. ~/.bashrc'
