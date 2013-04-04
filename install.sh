#!/bin/bash

absdir() {
    local dir="$1"
    (cd "$dir" && echo "$(pwd -P)")
}

relpath() {
    # both $1 and $2 are absolute paths beginning with /
    # returns relative path to $2/$target from $1/$src
    local src="$1"
    local target="$2"

    local common_part="$src" # for now
    local result="" # for now

    while [ "${target#$common_part}" = "$target" ]; do
        # no match, means that candidate common part is not correct
        # go up one level (reduce common part)
        common_part="$(dirname "$common_part")"
        # and record that we went back, with correct / handling
        if [ -z "$result" ]; then
            result=".."
        else
            result="../$result"
        fi
    done

    if [ "$common_part" = "/" ]; then
        # special case for root (no common path)
        result="$result/"
    fi

    # since we now have identified the common part,
    # compute the non-common part
    forward_part="${target#$common_part}"

    # and now stick all parts together
    if [ -n "$result" ] && [ -n "$forward_part" ]; then
        result="$result$forward_part"
    elif [ -n "$forward_part" ]; then
        # extra slash removal
        result="${forward_part:1}"
    fi

    echo "$result"
}

usage() {
    echo "Usage: $0 [-f] [target]" >&2
    exit 1
}

src="$(dirname "$0")"
force=
target="$HOME"

while getopts f opt; do
    if [ "$opt" = f ]; then
        force=y
    else
        usage
    fi
done

shift $(( $OPTIND - 1 ))
if [ $# -gt 1 ]; then
    usage
fi

if [ -n "$1" ]; then
    target="$1"
fi

read -p "Do you want to install settings to \`$target'? (y/N) " answer

if [ "$answer" != 'y' ]; then
    echo Aborted.
    exit 2
fi

install_ln() {
    local src="$1"
    local target="$2"
    local abssrc="$(absdir "$src")"
    local abstarget="$(absdir "$target")"

    local base="$(relpath "$abstarget" "$abssrc")"
    mkdir -p "$target"
    for f in $(find "$abssrc" -type f); do
        local file="$(basename $f)"
        if [ -e "$target/$file" -a "$force" != y ]; then
            echo "$target/$file already exists, try with -f to overwrite." >&2
            exit 3
        fi

        ln -sf "$base/$file" "$target/"
        echo "$src/$file is installed to $target"
    done
}

install_ln "$src/dotfiles" "$target"
install_ln "$src/bin" "$target/bin"
