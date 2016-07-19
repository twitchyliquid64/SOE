#!/bin/bash

. ~/SOE/util/color.sh

exitstatus()
{
    if [[ $? == 0 ]]; then
        echo $WHITE
    else
        echo $RED
    fi
}

export PS1='$GREEN[\u@\h]$NC: $LIGHTBLUE\w$NC-$(exitstatus)$?$NC> '

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
export PROMPT_COMMAND='history -a'
