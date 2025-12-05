#!/usr/bin/env bash

cpu=$(ps -A -o %cpu= 2>/dev/null | awk '{s+=$1} END {printf "%.1f%%", s}')
mem=$(ps -A -o %mem= 2>/dev/null | awk '{s+=$1} END {printf "%.1f%%", s}')

echo "CPU ${cpu} MEM ${mem}"
