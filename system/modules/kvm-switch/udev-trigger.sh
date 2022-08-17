#!/usr/bin/env bash

# pipe everything to logger
exec 1> >(logger -s -t $(basename $0)) 2>&1

if [ -f /tmp/yusef-kvm-ignore ]; then
  echo "ignoring kvm event. remove /tmp/yusef-kvm-ignore to re-enable"
  exit 0
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# TODO: don't hardcode these
OUR_INPUT="HDMI_3"
OTHER_INPUT="HDMI_1"
OTHER_MAC_ADDR="e0:d5:5e:d4:2a:4e"

# config file for lgtv is in /root/.config/lgtv/config
# need to set HOME when called by udev
export HOME=/root
CONFIG_FILE="/root/.config/lgtv/config"

LGTV="$DIR/lgtv -c $CONFIG_FILE"

function device_added() {
  echo "switching TV to $OUR_INPUT"
  $LGTV tv switchInput $OUR_INPUT
}

function device_removed() {
  echo "switching TV to $OTHER_INPUT and sending WoL packet to $OTHER_MAC_ADDR"
  $DIR/wakeonlan $OTHER_MAC_ADDR
  $LGTV tv switchInput $OTHER_INPUT
}

if [ "$1" == "add" ]; then
  device_added
elif [ "$1" == "remove" ]; then
  device_removed
else
  echo "usage: $0 [add|remove]"
  exit 1
fi
