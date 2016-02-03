#!/bin/sh
#
# /etc/init.d/qdbd
# Subsystem file for "quasardb" server
#
# chkconfig: 2345 60 40
# description: quasardb server daemon
#
# processname: qdbd
# config: /etc/qdb/qdbd.conf
# pidfile: /var/run/qdb/qdbd.pid

# source function library
. /etc/init.d/functions

RETVAL=0

prog=qdbd
exec=/usr/bin/qdbd
pidfile=/var/run/qdb/qdbd.pid
lockfile=/var/lock/subsys/qdbd

if [ $UID -ne 0 ] ; then
    echo "User has insufficient privilege."
    exit 4
fi

start() {
    echo -n $"Starting $prog:"
    runuser qdb -g qdb -s /bin/sh -c '/usr/bin/qdbd -c /etc/qdb/qdbd.conf'
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