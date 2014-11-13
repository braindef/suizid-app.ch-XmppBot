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
ERRORLOG="/var/log/concierge.error"
VERSION=0.0.1
#MODPROBE=/sbin/modprobe
APPUSER=root
APPDIR=/root/suizid-app.ch-XmppBot/
APPCMD=concierge.py
JID="server@suizid-app.ch"
PASSWORD="password"


temp=$(ps -x |grep concierge.py |grep python |wc -l)

case "$1" in
  start)
        if [ "$temp" -eq "0" ]
        then
        	echo -n "Starting concierge-service"
		cd $APPDIR
		/bin/su - $APPUSER -c "$APPDIR$APPCMD -j $JID -p $PASSWORD >>$LOG 2>>$ERRORLOG &"
	else
		echo already running
		exit 1
	fi
        	echo -n "Starting new-service"
        ;;
  stop)
        echo -n "Stopping concierge-service"
        #To run it as root:
        #/path/to/command/to/stop/new-service
        #Or to run it as some other user:
        ps aux | grep concierge | grep -v "grep concierge" | awk '{print $2}' | xargs kill -HUP
        echo "."
        ;;

  *)
        echo "Usage: /sbin/service new-service {start|stop}"
        exit 1
esac

exit 0
