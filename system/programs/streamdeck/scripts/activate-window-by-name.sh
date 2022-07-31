#!/usr/bin/env bash

fallbackCommand="$2"

function fallback {
  if [ "$fallbackCommand" != "" ]; then
    $fallbackCommand
  fi
}

# seems to happen when window is minimized to tray (e.g. slack)
# error message is logged, but xdotool returns success status.
function has_error {
  local out=$1
  echo
  echo $out | grep "XGetWindowProperty\[_NET_WM_DESKTOP\] failed" >/dev/null
}

output=$(xdotool search --name "$1" windowactivate 2>&1)
status=$?

if [[ $status -ne 0 ]] || has_error "$output"; then
  fallback
fi
