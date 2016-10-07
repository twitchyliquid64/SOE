#!/bin/bash

#@function wd
#@description Saves the current working directory under a name.
#@usage $1 The name to save the working directory to.
wd(){
    pwd > "$HOME/.lastdir_$1"
}

#@function rd
#@description Restores a previously saved working directory (Saved using 'wd').
#@usage $1 The name of the previously saved entry.
rd(){
        lastdir="$(cat "$HOME/.lastdir_$1")">/dev/null 2>&1
        if [ -d "$lastdir" ]; then
                cd "$lastdir"
        else
                echo "no existing directory stored in buffer $1">&2
        fi
}
