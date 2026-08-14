#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Switch Monitor
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️

# Documentation:
# @raycast.description Toggle the Dell U2725QE KVM between its two inputs
# @raycast.author Brandon

# The two inputs this monitor's KVM cycles between.
INPUT_A=15
INPUT_B=25

M1DDC=/opt/homebrew/bin/m1ddc

# Bail out cleanly on any machine that isn't part of this KVM:
# no m1ddc installed (non Apple-Silicon / non-Mac), or the monitor
# isn't currently showing this machine (get input won't return 15/25).
if [ ! -x "$M1DDC" ]; then
  echo "m1ddc not installed — not this KVM's machine"
  exit 0
fi

current=$("$M1DDC" get input 2>/dev/null)

if [ "$current" != "$INPUT_A" ] && [ "$current" != "$INPUT_B" ]; then
  echo "Monitor not controllable from here (input: ${current:-none})"
  exit 0
fi

if [ "$current" = "$INPUT_A" ]; then
  "$M1DDC" set input "$INPUT_B" >/dev/null
  echo "Switched to input $INPUT_B"
else
  "$M1DDC" set input "$INPUT_A" >/dev/null
  echo "Switched to input $INPUT_A"
fi
