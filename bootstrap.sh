#!/usr/bin/env bash

if [ ! -d "persona" ]; then
  echo "Cloning persona"
  git clone git@github.com:persona-ae/persona.git
else
  echo "The persona repo already exists"
fi

if [ ! -d "dev" ]; then
  echo "Cloning dev"
  git clone git@github.com:colmpat/dev.git
else
  echo "The dev repo already exists"
fi


cp ./colm-dev-Dockerfile.dev persona/dockerfiles/

EXCLUDE_FILE="persona/.git/info/exclude"
PATTERN="^colm-dev"

# Ensure the exclude file exists
mkdir -p "$(dirname "$EXCLUDE_FILE")"
touch "$EXCLUDE_FILE"

# Check if "colm-dev" is already in the exclude file
if ! grep -q "$PATTERN" "$EXCLUDE_FILE"; then
  echo "Appending 'colm-dev*' to $EXCLUDE_FILE"
  echo "colm-dev*" >> "$EXCLUDE_FILE"
else
  echo "'colm-dev' already exists in $EXCLUDE_FILE"
fi

