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
fi

TIDDLYCTL_CONFIG=""
if [ -z "$TIDDLYCTL_CONFIG" ] ; then
    TIDDLYCTL_CONFIG="/opt/tiddlywiki/etc/tiddlyctl"
fi
# shellcheck disable=SC1090
. "$TIDDLYCTL_CONFIG"
if [ ! -e "$TIDDLYCTL_CONFIG" ] ; then
    problems "unable to open ${TIDDLYCTL_CONFIG}"
fi

if [ $# == 1 ] && [ "$1" == "list" ] ; then
    if [ "$OS" == "Darwin" ] ; then
        launchctl list | grep "$TIDDLYWIKI_NS_PREFIX"
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
    fi
    if [ -z "$ST" ] || [ "$ST" == "-" ] ; then
        echo "Not running"
        exit 1
    else
        echo "Running"
        exit 0
    fi
elif [ "$ACTION" == "stop" ] ; then
    if [ "$OS" == "Darwin" ] ; then
        launchctl stop "${TIDDLYWIKI_NS_PREFIX}.${TWIKI}"
    fi
elif [ "$ACTION" == "start" ] ; then
    if [ "$OS" == "Darwin" ] ; then
        launchctl start "${TIDDLYWIKI_NS_PREFIX}.${TWIKI}"
    fi
fi
