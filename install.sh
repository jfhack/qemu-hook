#!/bin/bash

echo "QEMU Hook Installer"
echo "==================="

HOOK_DIR="/etc/libvirt/hooks"
CURRENT=$(dirname $(realpath -s $0))
CONFIG_FILE="$CURRENT/config.json"

read -e -p "Config file absolute path : " -i "$CONFIG_FILE" CONFIG_FILE

if [ -z "$CONFIG_FILE" ]
then
  echo "Config file is required"
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  BASE_CONFIG_FILE="$CURRENT/config.json.example"
  if [ -f "$BASE_CONFIG_FILE" ]; then
    echo "Copying $BASE_CONFIG_FILE to $CONFIG_FILE"
    cp "$BASE_CONFIG_FILE" "$CONFIG_FILE"
  else
    echo "Config file not found"
    exit 1
  fi
fi

if [ ! -d "$HOOK_DIR" ]
then
  echo "Creating $HOOK_DIR"
  sudo mkdir -p $HOOK_DIR
fi

SCRIPT=$(sed 's|"config.json"|"'$CONFIG_FILE'"|g' "$CURRENT/qemu")

if ! which python > /dev/null
then
  SCRIPT=$(echo "$SCRIPT" | sed 's|python|python3|g')
fi

echo "Installing hook"
echo "$SCRIPT" | sudo tee "$HOOK_DIR/qemu" > /dev/null
