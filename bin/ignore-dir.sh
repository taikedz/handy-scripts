#!/usr/bin/env bash

[[ -n "$1" ]] || {
    echo "No directory specified"
    exit 1
}

mkdir -p "$1"
echo "*" >> "$1/.gitignore"
