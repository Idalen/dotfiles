#!/bin/sh

if [ -f "$CONFIG_DIR/colors.sh" ]; then
  # Use shared color palette when available.
  . "$CONFIG_DIR/colors.sh"
fi

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

if [[ "$CHARGING" != "" ]]; then
  ICON=""
fi

if [ "$PERCENTAGE" -le 20 ]; then
  PASTEL_COLOR="${PASTEL_RED}"
  INTENSE_COLOR="${RED}"
elif [ "$PERCENTAGE" -le 70 ]; then
  PASTEL_COLOR="${PASTEL_YELLOW}"
  INTENSE_COLOR="${YELLOW}"
else
  PASTEL_COLOR="${PASTEL_GREEN}"
  INTENSE_COLOR="${GREEN}"
fi

if [[ "$CHARGING" != "" ]]; then
  COLOR="$INTENSE_COLOR"
else
  COLOR="$PASTEL_COLOR"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" \
                          icon.color="$COLOR" label.color="$COLOR"
