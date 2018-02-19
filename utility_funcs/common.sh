#!/bin/bash

#Detect running platform
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
fi
if [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced
fi

#Timestamps
#@alias stamp
#@description Returns a single string with no spaces, representing the current date and time. Output represents the current timezone.
alias stamp='date "+%Y%m%d%a%H%M"'
#@alias da
#@description Returns a human-friendly datetime string in the current timezone.
alias da='date "+%Y-%m-%d %A    %T %Z"'

# search for a package
#@alias search
#@description Searches for a package using apt-cache.
#@usage $1 the search term to search for.
alias search="apt-cache search"

#@alias path
#@description Prints a list of all the directories in path, one per line.
alias path='echo -e ${PATH//:/\\n}'

#@alias ff
#@description Find a given file in ./ or lower directory.
#@usage $1 Filename to search for
alias ff='find . -name '



#@alias gitf_gopkg
#@description Lists all .git folder subdirectories in src/, excluding packages used for source management by go-plus atom integration.
alias gitf_gopkg='find ./src | grep \\.git/ | grep -v -e /goreturns/ | grep -v -e /delve/ | grep -v -e /gomodifytags/ | grep -v -e /gometalinter/ | grep -v -e /godef/ | grep -v -e /gogetdoc/ | grep -v -e /gocode/'


# some more ls aliases
if [[ $platform == 'linux' ]]; then
  alias ls='ls -hF --color'    # add colors for filetype recognition
fi
alias lx='ls -lXB'        # sort by extension
alias lk='ls -lSr'        # sort by size
alias la='ls -Al'        # show hidden files
alias lr='ls -lR'        # recursice ls
alias lt='ls -ltr'        # sort by date
alias lm='ls -al |more'        # pipe through 'more'
alias tree='tree -Cs'        # nice alternative to 'ls'
alias ll='ls -l'        # long listing
alias l='ls -hF --color'    # quick listing
alias lsize='ls --sort=size -lhr' # list by size
alias l?='cat /home/will/technical/tips/ls'
alias lsd='ls -l | grep "^d"'   #list only directories

alias fix_last_commit_msg='git -c user.name="twitchyliquid64" -c user.email=twitchyliquid64@ciphersink.net commit --amend --reset-author'

#@function weather
#@description Prints details about the weather in Sydney.
weather ()
{
  declare -a WEATHERARRAY
  WEATHERARRAY=( `curl --raw http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=Sydney | perl -ne '/<title>([^<]+)/&&printf "%s: ",$1;/<fcttext>([^<]+)/&&print $1,"\n"'`)
  echo ${WEATHERARRAY[@]}
}

# Get IP (call with myip)
#@function myip
#@description Returns your current WAN IP.
function myip {
  myip=`wget -q -O - https://api.ipify.org`
  echo "${myip}"
}


#@function time-in
#@description Prints the time in a timezone. Accepted values are: San Fran,New York, LA, MTV, Brisbane, Perth, Zurich, France, Spain, Amsterdam, London, Toronto, China.
#@usage $1 The locality to print the time in.
time-in ()
{
  case $1 in
      LA)           env TZ='America/Los_Angeles' date    ;;
      MTV)          env TZ='America/Los_Angeles' date    ;;
      San)          env TZ='America/Los_Angeles' date    ;;
      san)          env TZ='America/Los_Angeles' date    ;;

      New)          env TZ='America/New_York' date       ;;
      new)          env TZ='America/New_York' date       ;;

      Zurich)       env TZ='Europe/Zurich' date          ;;
      France)       env TZ='Europe/Paris'  date          ;;
      Madrid)       env TZ='Europe/Madrid' date          ;;
      Spain)        env TZ='Europe/Madrid' date          ;;
      Amsterdam)    env TZ='Europe/Amsterdam' date       ;;
      London)       env TZ='Europe/London' date          ;;
      Toronto)      env TZ='Canada/Eastern' date         ;;

      China)        env TZ='Asia/Shanghai' date          ;;
      Shanghai)     env TZ='Asia/Shanghai' date          ;;
      Shenzhen)     env TZ='Asia/Shanghai' date          ;;

      Perth)        env TZ='Australia/Perth' date        ;;
      Queensland)   env TZ='Australia/Brisbane' date     ;;
      Brisbane)     env TZ='Australia/Brisbane' date     ;;
      Townsville)   env TZ='Australia/Brisbane' date     ;;

      *)    echo "Don't know timezone '$1'. Accepted values are: San Fran,New York, LA, MTV, Brisbane, Perth, Zurich, France, Spain, Amsterdam, London, Toronto, China." ;;
  esac

}
