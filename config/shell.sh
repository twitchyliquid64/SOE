#!/bin/bash

. ~/SOE/util/color.sh

shopt -s promptvars dotglob histappend no_empty_cmd_completion cdspell xpg_echo


function status__
{
  echo `git status` | grep "Your branch is ahead" > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
    echo `git status` | grep "nothing to commit" > /dev/null 2>&1
    if [ "$?" -eq "1" ]; then
      printf "[dirty]"
    else
      printf "[ahead]"
    fi
  else
    echo `git status` | grep "nothing to commit" > /dev/null 2>&1
    if [ "$?" -eq "1" ]; then
      printf "[dirty]"
    fi
  fi
}

alias branchname="git branch 2>/dev/null | sed -ne 's/^* \(.*\)/ ${PARENCLR}(${BRANCHCLR}\1${PARENCLR}\)/p'"

export PS1='$GREEN[\u@\h]$NC:$LIGHTBLUE\w$NC$CYAN$(branchname)$YELLOW$(status__)$WHITE>$NC'






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

alias reload='. ~/.bashrc'
