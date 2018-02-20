#!/bin/bash
#
# This script does bash programmable completion for soe-help.

function _soe_help_complete(){
  local cur prev flag_list
  cur=$(_get_cword)
  prev=${COMP_WORDS[COMP_CWORD-1]}


  # Perform completion if the current word starts with a dash ('-'),
  # meaning that the user is trying to complete an option.
  if [[ ${cur} == -* ]] ; then
    flag_list="--system"
    COMPREPLY=( $(compgen -W "$flag_list" -- "$cur") )
    return 0
  fi

  # Perform completion on specific flags.
  case "$prev" in
    --system)
      COMPREPLY=( $(compgen -W "generate" -- "$cur") )
      return 0
      ;;
  esac

  # Perform completion on the command.
  cmds=`python ~/SOE/core/help.py commands`
  COMPREPLY=( $(compgen -W "$cmds" -- "$cur") )
  return 0
}

complete -o default -F _soe_help_complete soe-help
