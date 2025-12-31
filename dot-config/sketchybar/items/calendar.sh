#!/bin/bash

calendar=(
  icon=""
  icon.padding_left=12
  icon.padding_right=8
  label="--:--"
  label.width=70
  label.align=right
  label.padding_right=12
  padding_left=10
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
  background.color="$ITEM_BG"
  background.border_color="$TRANSPARENT"
  background.height=30
)

sketchybar --add item calendar right \
  --set calendar "${calendar[@]}" \
  --subscribe calendar system_woke
