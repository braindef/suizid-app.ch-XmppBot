#! /bin/sh
# Basic support for IRIX style chkconfig
###
# chkconfig: 235 98 55
# description: Manages the services you are controlling with the chkconfig command
###
### BEGIN INIT INFO
# Provides:       suizid-app
# Required-Start:
# Required-Stop:
# Default-Start:  3 4 5
# Default-Stop:   0 1 2 6
# Short-Description: VirtualBox Linux kernel module
### END INIT INFO

#PATH=/sbin:/bin:/usr/sbin:/usr/bin:$PATH
LOG="/var/log/concierge.log"
VERSION=0.0.1
#MODPROBE=/sbin/modprobe
APPUSER=root
APPCMD=/root/suizid-app.ch/suizid-app.ch-XmppBot/concierge.py

case "$1" in
  start)
        echo -n "Starting new-service"
        #To run it as root:
        #/path/to/command/to/start/new-service
        #Or to run it as some other user:
        /bin/su - $APPUSER -c $APPCMD >$LOG
        echo "."
        ;;
  stop)
        echo -n "Stopping new-service"
        #To run it as root:
        /path/to/command/to/stop/new-service
        #Or to run it as some other user:
        /bin/su - username -c killall consierge.py
        echo "."
        ;;

  *)
        echo "Usage: /sbin/service new-service {start|stop}"
        exit 1
esac

exit 0
