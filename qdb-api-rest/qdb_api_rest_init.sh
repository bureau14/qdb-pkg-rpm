#!/bin/sh
#
# /etc/init.d/qdb_api_rest
# Subsystem file for "quasardb" server
#
# chkconfig: 2345 60 40
# description: quasardb api rest
#
# processname: qdb_api_rest
# config: /etc/qdb/qdb-api-rest.cfg
# pidfile: /var/run/qdb/qdb_api_rest.pid

# source function library
. /etc/init.d/functions

RETVAL=0

prog=qdb_api_rest
exec=/usr/bin/qdb-api-rest-server
pidfile=/var/run/qdb/qdb_api_rest.pid
lockfile=/var/lock/subsys/qdb_api_rest

if [ $UID -ne 0 ] ; then
    echo "User has insufficient privilege."
    exit 4
fi

start() {
    echo -n $"Starting $prog:"
    mkdir -p /var/run/qdb
    runuser qdb -g qdb -s /bin/sh -c '/usr/bin/qdb-api-rest-server --config-file /etc/qdb/qdb-api-rest.cfg  &'
    RETVAL=$?
    echo
    [ "$RETVAL" = 0 ] && touch $lockfile && /sbin/pidof $exec > $pidfile
    return $RETVAL
}

stop() {
    echo -n $"Stopping $prog:"
    killproc $exec -TERM
    RETVAL=$?
    echo
    [ "$RETVAL" = 0 ] && rm -f $lockfile
    return $RETVAL
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    condrestart)
        if [ -f /var/lock/subsys/$prog ] ; then
            stop
            # avoid race
            sleep 3
            start
        fi
        ;;
    status)
        status $prog
        RETVAL=$?
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|condrestart|status}"
        RETVAL=1
esac
exit $RETVAL