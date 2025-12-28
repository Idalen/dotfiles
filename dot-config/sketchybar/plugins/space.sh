#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.color=0xff89b4fa icon.color=0xff1e1e2e
else
  sketchybar --set "$NAME" background.color=0x551e1e2e icon.color=0xff7f849c
fi
