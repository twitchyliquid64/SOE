#!/bin/bash



#@function for_py
#@description Runs the given shell command for every .py file in pwd. The name of the .py file will be passed to the shell command the first argument. Command can be arbitrarily complex.
#@usage $1 The command to run
function for_py {
  for i in *.py
  do
    evalStr="$1 $i"
    echo $evalStr
    eval $evalStr
  done
}

#@function for_file_r
#@description Runs the given shell command for every file matching the given name. When executed, it will look like: <shell-command> <relative path to file>
#@usage $1 The command to run
#@usage $2 File name pattern
function for_file_r {
  for i in `find . -name $2`
  do
    evalStr="$1 $i"
    eval $evalStr
  done
}


#@alias purge_git_metadata_recursive
#@description Recursively deletes all .git folders in current/child directories. BE CAREFUL - it will also delete any file with the word git in the filename.
alias purge_git_metadata_recursive='find . | grep .git | xargs rm -rf'
