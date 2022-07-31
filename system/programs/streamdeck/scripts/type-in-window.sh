#!/usr/bin/env bash

if [[ "$3" == "--activate" ]]; then
  exec xdotool search --name "$1" windowactivate key "$2"
else
  exec xdotool search --name "$1" key "$2"
fi
