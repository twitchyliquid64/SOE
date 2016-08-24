#!/bin/bash

#@function soe-help
#@description provides documentation about commands available through SOE. Auxillary options also allow maintainance of the database.
#@usage $1 command to retrieve help information for, or '--system'
#@usage $2 if '--system' is specified as the first parameter, this parameter is the maintainance command to execute on the help database.
function soe-help () {
    if [ "$1" = "--system" ]; then
      python ~/SOE/core/help.py $2
    else
      python ~/SOE/core/help.py help $1
    fi
}

#@function soe-commands
#@description Lists all commands made available through SOE.
function soe-commands () {
  python ~/SOE/core/help.py commands
}
