#!/usr/bin/env bash

set -eu

dbg() {
    >&2 echo "$*"
}
problems() {
    dbg "Problems: ${1}"
    exit 1
}

declare OS
if [ -z "$OS" ] ; then
    OS="$(uname -s)"
    if [ "$OS" == "Linux" ] && \
           uname -v | grep "Mirosoft" &> /dev/null ; then
        OS="WSL"
    fi
fi

if [ -z "${TIDDLYCTL_CONFIG+x}" ] ; then
    TIDDLYCTL_CONFIG="/opt/tiddlywiki/etc/tiddlyctl"
fi
# shellcheck disable=SC1090
. "$TIDDLYCTL_CONFIG"
if [ ! -e "$TIDDLYCTL_CONFIG" ] ; then
    problems "unable to open ${TIDDLYCTL_CONFIG}"
fi

if [ $# == 1 ] && [ "$1" == "list" ] ; then
    if [ -z "$TIDDLYWIKIS" ] ; then
        echo "no wikis configured"
    else
        echo -e "${TIDDLYWIKIS// /'\n'}"
    fi
    exit 0
fi

if [ $# -lt 2 ] ; then
    problems "invalid args"
fi
TWIKI="$1"
ACTION="$2"
shift 2

if [ "$ACTION" == "status" ] ; then
    if [ "$OS" == "Darwin" ] ; then
        ST=$(launchctl list | grep "${TIDDLYWIKI_NS_PREFIX}.${TWIKI}" | awk '{ print $1 }')
        if [ -z "$ST" ] || [ "$ST" == "-" ] ; then
            echo "Not running"
            exit 1
        else
            echo "Running"
            exit 0
        fi
    elif [ "$OS" == "WSL" ] ; then
        "${TIDDLYWIKI_INIT}/${TWIKI}" "$ACTION"
    else
        echo "unsupported context"
        exit 1
    fi
elif [ "$ACTION" == "stop" ] || [ "$ACTION" == "start" ] ; then
    if [ "$OS" == "Darwin" ] ; then
        launchctl "$ACTION" "${TIDDLYWIKI_NS_PREFIX}.${TWIKI}"
    elif [ "$OS" == "WSL" ] ; then
        "${TIDDLYWIKI_INIT}/${TWIKI}" "$ACTION"
    else
        echo "unsupported context"
        exit 1
    fi
else
    echo "unsupported action"
    exit 1
fi
