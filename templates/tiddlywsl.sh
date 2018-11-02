#!/usr/bin/env bash
set -e

TIDDLYWIKI_PIDFILE="{{tiddlywiki_pid_directory}}/{{item.name}}"
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

check_pid() {
    if [ -e "$TIDDLYWIKI_PIDFILE" ] ; then
        TIDDLWIKI_PID="$(cat "$TIDDLYWIKI_PIDFILE")"
        if [ ! -z "$TIDDLYWIKI_PID" ] && ps "$TIDDLYWIKI_PID" &> /dev/null ; then
            return
        else
            TIDDLYWIKI_PID=""
            rm "$TIDDLYWIKI_PIDFILE"
        fi
    fi
    
}

do_start() {
    check_pid
    if [ ! -z "$TIDDLYWIKI_PID" ] ; then
        echo "{{item.name}} already running $(cat "$TIDDLYWIKI_PIDFILE")"
    else
        nohup tiddlywiki "$TIDDLYWIKI_DATA" \
              --server "$TIDDLYWIKI_PORT" \
            &> "$TIDDLYWIKI_LOG" &
        TPID="$!"
        if ps "$TPID" &> /dev/null ; then
            echo "$TPID" > "$TIDDLYWIKI_PIDFILE"
            echo "Started {{item.name}}"
        else
            echo "Unable to start {{item.name}}"
            exit 1
        fi
    fi
}

do_stop() {
    check_pid
    if [ ! -z "$TIDDLYWIKI_PID" ] ; then
        kill "$TIDDLYWIKI_PID"
        echo "Stopped {{item.name}}"
        rm "$TIDDLYWIKI_PIDFILE"        
    else
        echo "{{item.name}} is not running"
    fi
}

do_status() {
    if [ -f "$TIDDLYWIKI_PIDFILE" ] ; then
        TPID="$(cat "$TIDDLYWIKI_PIDFILE")"
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
