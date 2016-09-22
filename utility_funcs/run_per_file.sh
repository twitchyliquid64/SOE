#!/bin/bash



# Runs the given function for every .py file
#@function for_py
#@description Runs the given command for every .py file in pwd.
function for_py {
  for i in *.py
  do
    evalStr="$1 $i"
    echo $evalStr
    eval $evalStr
  done
}
