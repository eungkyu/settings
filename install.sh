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
    echo "Usage: $0 [-f] [-c] [target]" >&2
    exit 1
}

src="$(dirname "$0")"
force=n
copy=n
target="$HOME"

while getopts fc opt; do
    if [ "$opt" = f ]; then
        force=y
    elif [ "$opt" = c ]; then
        copy=y
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

check() {
    if [ "$copy" == n ]; then
        check_ln "$@"
    else
        check_cp "$@"
    fi
}

check_ln() {
    local src="$1"
    local target="$2"

    mkdir -p "$target"

    local abssrc="$(absdir "$src")"
    local abstarget="$(absdir "$target")"

    local base="$(relpath "$abstarget" "$abssrc")"
    for f in $(find "$abssrc" -type f); do
        local file="$(basename "$f")"
        if [ -L "$target/$file" ]; then
            local link="$(readlink "$target/$file")"
            if [ "$link" = "$link" ]; then
                continue
            fi
        fi

        if [ -e "$target/$file" -a "$force" == n ]; then
            echo "$target/$file already exists, try with -f to overwrite." >&2
            exit 3
        fi
    done
}

check_cp() {
    local src="$1"
    local target="$2"

    mkdir -p "$target"

    for f in $(find "$src" -type f); do
        local file="$(basename "$f")"
        if [ -e "$target/$file" -a "$force" == n ]; then
            echo "$target/$file already exists, try with -f to overwrite." >&2
            exit 3
        fi
    done
}

install() {
    if [ "$copy" == n ]; then
        install_ln "$@"
    else
        install_cp "$@"
    fi
}

install_ln() {
    local src="$1"
    local target="$2"

    mkdir -p "$target"

    local abssrc="$(absdir "$src")"
    local abstarget="$(absdir "$target")"

    local base="$(relpath "$abstarget" "$abssrc")"
    for f in $(find "$abssrc" -type f); do
        local file="$(basename "$f")"
        ln -sf "$base/$file" "$target/"
        echo "$src/$file is installed to $target"
    done
}

install_cp() {
    local src="$1"
    local target="$2"

    mkdir -p "$target"

    for f in $(find "$src" -type f); do
        local file="$(basename "$f")"
        rm -f "$target/$file"
        cp "$f" "$target/"
        echo "$f is installed to $target"
    done
}

check "$src/dotfiles" "$target"
check "$src/bin" "$target/bin"

install "$src/dotfiles" "$target"
install "$src/bin" "$target/bin"
