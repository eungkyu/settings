#!/bin/bash

usage() {
    echo "Usage: $0 [target]" >&2
    exit 1
}

src="$(dirname "$0")"
target="$HOME"

if [ $# -gt 1 ]; then
    usage
fi

if [ -n "$1" ]; then
    target="$1"
fi

read -p "Do you want to apply settings from \`$target'? (y/N) " answer

if [ "$answer" != 'y' ]; then
    echo Aborted.
    exit 2
fi


apply() {
    local src="$1"
    local target="$2"

    mkdir -p "$target"

    for f in $(find "$src" -type f); do
        local file="$(basename "$f")"
        cp -f "$target/$file" "$src/"
        echo "$target/$file is applied to $src"
    done
}

apply "$src/dotfiles" "$target"
apply "$src/bin" "$target/bin"
