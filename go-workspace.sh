#!/bin/bash
# vim: sw=4 et:

# Name:
#    go-workspace.sh
# Purpose:
#     Configure a Go workspace and essential environment variables.
# Usage:
#    go-workspace.sh [-h|-u]
#    go-workspace.sh [-g <GOPATH>] [-b <GOBIN>] [-s <SHELLRC>] [-d] [-v]
# Options:
#    -h = show documentation
#    -u = show usage
#    -v = show variables and exit
#    -d = debugging
#    -g = GOPATH (path to Go tree)
#    -b = GOBIN (path to binaries Go compiles)
#    -s = SHELLRC (path to shell startup file)
# Copyright:
#    Copyright 2014 Todd A. Jacobs
# License:
#    Released under the GNU General Public License (GPL)
#    http://www.gnu.org/copyleft/gpl.html
#
#    This program is free software; you can redistribute it and/or
#    modify it under the terms of the GNU General Public License as
#    published by the Free Software Foundation; either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful, but
#    WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    General Public License for more details.

######################################################################
# Functions
######################################################################
bail_when_no_startup () {
    if [[ -n $NO_STARTUP ]]; then
        echo 'ENOENT: Shell startup file not found.' >&2
        exit 2
    fi
}

init () {
    set -e
    set -o noclobber

    : ${GOPATH:=\$HOME/go}
    : ${GOBIN:=\$GOPATH/bin}

    # Heuristics if SHELLRC is unset.
    if  [[ -n $SHELLRC ]]; then
        [[ -f "$SHELLRC" ]] || NO_STARTUP=true
    elif [[ -w ~/.profile ]]; then
        SHELLRC="$HOME/.profile"
    elif [[ -w ~/.bash_profile ]]; then
        SHELLRC="$HOME/.bash_profile"
    elif [[ -w ~/.bashrc ]]; then
        SHELLRC="$HOME/.bashrc"
    else
        NO_STARTUP=true
    fi
}

mktree () {
    mkdir -p "${GOPATH}/"{src,pkg,bin}
}

# Process command-line options. Returns number of positional parameters
# to shift away after calling this function.
options () {
    while getopts ':dhuvb:g:s:' opt; do
        case $opt in
            b)  GOBIN="$OPTARG"
                ;;
            d)  set -x
                ;;
            g)  GOPATH="$OPTARG"
                ;;
            h)  show_help
                ;;
            s)  SHELLRC="$OPTARG"
                ;;
            v)  show_variables GOPATH GOBIN SHELLRC
                EXIT=true
                ;;
            \? | u) show_usage
                ;;
        esac
    done
    [[ -n $EXIT ]] && exit
    return $(($OPTIND - 1))
}

show_help () {
    perl -ne 'if (/^# Name:/ .. /^$/) {
                  s/^# ?//;
                  s/^\S/\n$&/;
                  print;
              }' $0
    exit
}

show_usage () {
    perl -ne 'if (/^# Usage:/ ... /^# \S/) {
                 s/^# ?//;
                 print unless /^\S/ && /^(?!Usage:)/;
             }' $0
    exit
}

# Display list of flag values.
show_variables () {
    for var in $*; do
        echo -e "    $var:\t\t${!var}"
    done
}

update_shellrc () {
    if ! grep -Fq GOPATH "$SHELLRC"; then
        echo "export GOPATH='$GOPATH'" >> "$SHELLRC"
    fi

    if ! grep -Fq GOBIN "$SHELLRC"; then
        echo "export GOBIN='$GOBIN'" >> "$SHELLRC"
    fi

    # Ensure GOBIN is appended to PATH.
    if ! { grep -F PATH "$SHELLRC" | grep -Eq "[$]GOBIN|$GOBIN"; }; then
        echo 'export PATH="$PATH:$GOBIN"' >> "$SHELLRC"
    fi
}

######################################################################
# Main
######################################################################
init
options "$@" || shift $?
bail_when_no_startup
mktree
update_shellrc
