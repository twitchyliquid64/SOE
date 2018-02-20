#!/bin/bash
#
# This script does bash programmable completion for soe-tool.

function _soe_tool_complete(){
  local cur prev flag_list
  cur=$(_get_cword)
  prev=${COMP_WORDS[COMP_CWORD-1]}

  if [[ ${prev} == 'soe-tool' ]] ; then
    COMPREPLY=( $(compgen -W "install" -- "$cur") )
    return 0
  fi

  # Perform completion on the command.
  tools=`python ~/SOE/core/list_tools.py`
  COMPREPLY=( $(compgen -W "$tools all" -- "$cur") )
  return 0
}

complete -o default -F _soe_tool_complete soe-tool
