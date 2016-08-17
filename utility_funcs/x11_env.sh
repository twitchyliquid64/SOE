#!/bin/bash
#shortcuts for working within a graphical environment

#what about: xdotool windowactivate --sync "$(xdotool getactivewindow)" key ctrl+r
keypress () {
	env DISPLAY=:0 xdotool key $1
}
