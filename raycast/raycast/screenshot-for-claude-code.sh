#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Screencap
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Copy screen capture to clipboard
# @raycast.author Brandon

screencapture -i /tmp/screenshot.png
osascript -e 'set the clipboard to (read (POSIX file "/tmp/screenshot.png") as TIFF picture)'

