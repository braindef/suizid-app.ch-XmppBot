#! /bin/sh

### BEGIN INIT INFO
# Provides:          concierge.py
# Required-Start:    $ejabberd
# Required-Stop:     $ejabberd
# Should-Start:      
# Should-Stop:       
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start and stop xmpp bot for suicide prevention app
# Description:       suicide prevention app
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
		echo starting... $(date) >>$LOG
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
        echo stopping... $(date) >>$LOG
	ps aux | grep concierge | grep -v "grep concierge" | awk '{print $2}' | xargs kill -HUP
        ;;
  status)
        ps aux | grep concierge | grep -v "grep concierge"
        ;;
  restart)
        ps aux | grep concierge | grep -v "grep concierge" | awk '{print $2}' | xargs kill -HUP
	sleep 10
	/bin/su - $APPUSER -c "$APPDIR$APPCMD -j $JID -p $PASSWORD >>$LOG 2>>$ERRORLOG &"
	;;
  force-reload)
	        ps aux | grep concierge | grep -v "grep concierge" | awk '{print $2}' | xargs kill -HUP
        sleep 10
        /bin/su - $APPUSER -c "$APPDIR$APPCMD -j $JID -p $PASSWORD >>$LOG 2>>$ERRORLOG &"
        ;;
  *)
        echo "Usage: /sbin/service new-service {start|stop}"
        exit 1
esac

exit 0
