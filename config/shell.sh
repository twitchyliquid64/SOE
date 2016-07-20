#!/bin/bash

. ~/SOE/util/color.sh

shopt -s promptvars dotglob histappend no_empty_cmd_completion cdspell xpg_echo



function parse_git_dirty {
  echo -n $(git status 2>/dev/null | awk -v out=$1 -v std="dirty" '{ if ($0=="# Changes to be committed:") std = "uncommited"; last=$0 } END{ if(last!="" && last!="nothing to commit (working directory clean)") { if(out!="") print out; else print std } }')
}
function parse_git_remote {
  echo -n $(git status 2>/dev/null | awk -v out=$1 '/# Your branch is / { if(out=="") print $5; else print out }')
}
alias branchname="git branch 2>/dev/null | sed -ne 's/^* \(.*\)/ ${PARENCLR}(${BRANCHCLR}\1${PARENCLR}\)/p'"

export PS1='$GREEN[\u@\h]$NC: $LIGHTBLUE\w$NC$CYAN$(branchname)$YELLOW$(parse_git_dirty)$(parse_git_remote)$WHITE>$NC'






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
