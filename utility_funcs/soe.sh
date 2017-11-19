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

#@function soe-tool
#@description manages and installs SOE tools into the environment.
#@usage $1 sub-command, such as 'install'
#@usage $2 Name of the tool to install.
function soe-tool () {
    if [ "$1" = "install" ]; then
      sudo python ~/SOE/core/tool_installer.py $2
    else
      echo "Unknown sub-command '$1'"
    fi
}
