#!/bin/bash
# Found this script on
# https://bbs.archlinux.org/viewtopic.php?id=148267
while true; do
  sleep 30
  RUNNING=$(pacmd list-sink-inputs  | grep -w state | grep RUNNING)
  if [ -n "${RUNNING}" ]; then
    xdotool key shift
  fi
done
