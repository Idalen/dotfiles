#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
  sketchybar --set "$NAME" label="Install jq" icon="" drawing=on
  exit 0
fi

if [ -n "$INFO" ]; then
  PLAYER_STATE="$(echo "$INFO" | jq -r '.state')"
  CURRENT_SONG="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
  if [ "$PLAYER_STATE" = "playing" ]; then
    sketchybar --set "$NAME" label="$CURRENT_SONG" icon="" drawing=on
  else
    sketchybar --set "$NAME" drawing=off label=""
  fi
  exit 0
fi

if ! command -v osascript >/dev/null 2>&1; then
  sketchybar --set "$NAME" drawing=off label=""
  exit 0
fi

STATE="$(osascript -e 'tell application "Music" to if it is running then get player state')"
if [ "$STATE" = "playing" ]; then
  TITLE="$(osascript -e 'tell application "Music" to get name of current track')"
  ARTIST="$(osascript -e 'tell application "Music" to get artist of current track')"
  sketchybar --set "$NAME" label="$TITLE - $ARTIST" icon="" drawing=on
else
  sketchybar --set "$NAME" drawing=off label=""
fi
