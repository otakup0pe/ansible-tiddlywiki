#!/usr/bin/env bash
set -e

TIDDLYWIKI_PID="{{tiddlywiki_pid_directory}}/{{item.name}}"
TIDDLYWIKI_LOG="{{tiddlywiki_log_directory}}/{{item.name}}"
TIDDLYWIKI_DATA="{{item.path}}"
TIDDLYWIKI_PORT="{{item.port}}"

usage() {
    echo "${0} start"
    echo "${0} stop"
    echo "${0} status"
    echo "${0} restart"
    exit 1
}

do_start() {
    if [ ! -f "$TIDDLYWIKI_PID" ] ; then
        nohup tiddlywiki "$TIDDLYWIKI_DATA" \
              --server "$TIDDLYWIKI_PORT" \
            &> "$TIDDLYWIKI_LOG" &
        TPID="$!"
        if ps "$TPID" &> /dev/null ; then
            echo "$TPID" > "$TIDDLYWIKI_PID"
            echo "Started {{item.name}}"
        else
            echo "Unable to start {{item.name}}"
            exit 1
        fi
    else
        echo "{{item.name}} already running $(cat "$TIDDLYWIKI_PID")"
    fi
}

do_stop() {
    if [ -f "$TIDDLYWIKI_PID" ] ; then
        TPID="$(cat "$TIDDLYWIKI_PID")"
        if ps "$TPID" &> /dev/null ; then
            kill "$TPID"
            echo "Stopped {{item.name}}"
        else
            echo "{{item.name}} crashed"
        fi
        rm "$TIDDLYWIKI_PID"
    else
        echo "{{item.name}} is not running"
    fi
}

do_status() {
    if [ -f "$TIDDLYWIKI_PID" ] ; then
        TPID="$(cat "$TIDDLYWIKI_PID")"
        if ps "$TPID" &> /dev/null ; then
            echo "{{item.name}} running"
        else
            echo "{{item.name}} crashed"
        fi
    else
        echo "{{item.name}} is not running"
    fi
}

if [ "$#" != 1 ] ; then
    usage
fi

ACTION="$1"

if [ "$ACTION" == "start" ] ; then
    do_start
elif [ "$ACTION" == "stop" ] ; then
    do_stop
elif [ "$ACTION" == "status" ] ; then
    do_status
elif [ "$ACTION" == "restart" ] ; then
    do_stop
    do_start
else
    usage
fi
