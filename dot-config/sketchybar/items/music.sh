#!/bin/bash

music=(
  script="$PLUGIN_DIR/music.sh"
  label.padding_right=8
  padding_right=16
  icon=""
  drawing=off
  label=""
  scroll_texts=false
  icon.padding_left=12
  label.max_chars=20
  label.align=left
  label.width=140
  update_freq=5
  --subscribe music media_change system_woke
)

sketchybar \
  --add item music right \
  --set music "${music[@]}"
