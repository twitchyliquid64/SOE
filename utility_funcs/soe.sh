#!/bin/bash

function soe-help () {
    if [ "$1" = "--system" ]; then
      python ~/SOE/core/help.py $2
    else
      python ~/SOE/core/help.py help $1
    fi
}
