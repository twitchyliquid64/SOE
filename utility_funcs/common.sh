#!/bin/bash


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

# some more ls aliases
alias ls='ls -hF --color'    # add colors for filetype recognition
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


weather ()
{
  declare -a WEATHERARRAY
  WEATHERARRAY=( `elinks -dump "http://www.google.com/search?hl=en&lr=&client=firefox-a&rls=org.mozilla%3Aen-US%3Aofficial&q=weather+71822&btnG=Search" | grep -A 5 -m 1 "Weather for" | grep -v "Add to "`)
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
time-in ()
{
  case $1 in
      San)  env TZ='America/Los_Angeles' date    ;;
      New)  env TZ='America/New_York' date    ;;
      LA)   env TZ='America/Los_Angeles' date    ;;
      *)    echo "don't know timezone '$1'" ;;
  esac

}
