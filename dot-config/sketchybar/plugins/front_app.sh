#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

if [ "$SENDER" = "front_app_switched" ]; then
  icon="$(/bin/bash "$CONFIG_DIR/plugins/icon_map.sh" "$INFO")"
  if [ -z "$icon" ]; then
    icon=":default:"
  fi
  sketchybar --set "$NAME" label="$INFO" icon="$icon"
fi
