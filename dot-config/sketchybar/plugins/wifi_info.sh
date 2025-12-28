#!/bin/sh

STATE_FILE="/tmp/sketchybar_wifi_rate"

if [ -n "$WIFI_INTERFACE" ]; then
  IFACE="$WIFI_INTERFACE"
else
  IFACE="$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi|AirPort/{getline; print $2; exit}')"
fi

if [ -z "$IFACE" ]; then
  exit 0
fi

SSID="$(networksetup -getairportnetwork "$IFACE" 2>/dev/null | sed 's/^Current Wi-Fi Network: //')"
if [ -z "$SSID" ] || [ "$SSID" = "You are not associated with an AirPort network." ]; then
  SSID="No WiFi"
fi

STATS="$(netstat -bI "$IFACE" 2>/dev/null | awk -v iface="$IFACE" '$1==iface {print $7" "$10; exit}')"
RX_BYTES="$(printf "%s" "$STATS" | awk '{print $1}')"
TX_BYTES="$(printf "%s" "$STATS" | awk '{print $2}')"
NOW_TS="$(date +%s)"

if [ -f "$STATE_FILE" ]; then
  PREV_RX="$(awk '{print $1}' "$STATE_FILE")"
  PREV_TX="$(awk '{print $2}' "$STATE_FILE")"
  PREV_TS="$(awk '{print $3}' "$STATE_FILE")"
else
  PREV_RX=""
  PREV_TX=""
  PREV_TS=""
fi

printf "%s %s %s\n" "$RX_BYTES" "$TX_BYTES" "$NOW_TS" > "$STATE_FILE"

RATE_RX=0
RATE_TX=0
if [ -n "$PREV_RX" ] && [ -n "$PREV_TX" ] && [ -n "$PREV_TS" ]; then
  DT=$((NOW_TS - PREV_TS))
  if [ "$DT" -gt 0 ]; then
    DELTA_RX=$((RX_BYTES - PREV_RX))
    DELTA_TX=$((TX_BYTES - PREV_TX))
    if [ "$DELTA_RX" -gt 0 ]; then
      RATE_RX=$((DELTA_RX / DT))
    fi
    if [ "$DELTA_TX" -gt 0 ]; then
      RATE_TX=$((DELTA_TX / DT))
    fi
  fi
fi

format_rate() {
  local bytes="$1"
  if [ "$bytes" -ge 1048576 ]; then
    awk -v b="$bytes" 'BEGIN {printf "%.1fMB/s", b/1048576}'
  elif [ "$bytes" -ge 1024 ]; then
    awk -v b="$bytes" 'BEGIN {printf "%.0fKB/s", b/1024}'
  else
    printf "%dB/s" "$bytes"
  fi
}

DOWN="$(format_rate "$RATE_RX")"
UP="$(format_rate "$RATE_TX")"

sketchybar --set "$NAME" label="${SSID}  D ${DOWN}  U ${UP}"
