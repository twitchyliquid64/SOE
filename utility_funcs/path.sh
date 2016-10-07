#!/bin/bash
#Sets up functions which are useful for manipulating the PATH.

#@function path_append
#@description Adds the given argument to the shell's PATH.
#@usage $1 The path to append to PATH.
path_append ()  { path_remove $1; export PATH="$PATH:$1"; }
#@function path_prepend
#@description Adds the given argument to the shell's PATH as a first priority.
#@usage $1 The path to prepend to PATH.
path_prepend () { path_remove $1; export PATH="$1:$PATH"; }
#@function path_remove
#@description Removes all instances of the argument from the shell's PATH.
#@usage $1 The path to remove from PATH.
path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }
