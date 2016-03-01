#!/bin/sh
#
# /etc/init.d/qdb_httpd
# Subsystem file for "quasardb" web bridge
#
# chkconfig: 2345 80 20
# description: quasardb web bridge
#
# processname: qdb_httpd
# config: /etc/qdb/qdb_httpd.conf
# pidfile: /var/run/qdb_http/qdb_httpd.pid

# source function library
. /etc/init.d/functions

RETVAL=0

prog=qdb_httpd
exec=/usr/bin/qdb_httpd
pidfile=/var/run/qdb_http/qdb_httpd.pid
lockfile=/var/lock/subsys/qdb_httpd

if [ $UID -ne 0 ] ; then
    echo "User has insufficient privilege."
    exit 4
fi

start() {
    echo -n $"Starting $prog:"
    mkdir -p /var/run/qdb_http
    runuser qdb_http -g qdb_http -s /bin/sh -c '/usr/bin/qdb_httpd -c /etc/qdb/qdb_httpd.conf'
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