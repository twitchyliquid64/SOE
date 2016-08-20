#!/bin/bash
# This file should be source'ed by your bashrc or equivalent.

. ~/SOE/util/color.sh

#Load our config first
for f in ~/SOE/config/*.sh; do
  #echo $f
  if [ ! -d $f ]; then
    source $f;
  fi
done

#Load our functions second
for f in ~/SOE/utility_funcs/*.sh; do
  #echo $f
  if [ ! -d $f ]; then
    source $f;
  fi
done



path_append ~/SOE/scripts
