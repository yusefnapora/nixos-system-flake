#!/usr/bin/env bash

exec xdotool search --name "$1" key "$2"
