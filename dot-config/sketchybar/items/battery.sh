#!/bin/bash

battery=(
  script="$PLUGIN_DIR/battery.sh"
  padding_right=0
  padding_left=10
  label.drawing=on
  update_freq=120
  updates=on
  background.color="$ITEM_BG"
)

sketchybar --add item battery right \
  --set battery "${battery[@]}" \
  --subscribe battery power_source_change system_woke
