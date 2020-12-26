function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}


#!/bin/sh
xrandr --output LVDS1 --primary --mode 1366x768 --pos 1920x432 --rotate normal 
       --output DP1 --off 
       --output DP2 --off 
       --output DP3 --off 
       --output HDMI1 --off 
       --output HDMI2 --off 
       --output HDMI3 --off 
       --output VGA1 --mode 1920x1200 --pos 0x0 --rotate normal 
       --output VIRTUAL1 --off

# start utility applications at boottime
run variety &
