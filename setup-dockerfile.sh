#!/usr/bin/env bash

# Point Persona image to be based off of our image
FILE="persona/dockerfiles/Dockerfile.dev"
SEARCH="FROM mcr.microsoft.com/devcontainers/python:1-3.11-bookworm"
REPLACE="FROM colm-dev"

# Check if the file contains the target string
if grep -q "$SEARCH" "$FILE"; then
    # Replace the string
    sed -i "s|$SEARCH|$REPLACE|" "$FILE"
    echo "Updated $FILE"
else
    echo "No changes made. '$SEARCH' not found in $FILE"
fi


# Populate our image
cp -v ./colm-dev-Dockerfile.dev persona/dockerfiles/

