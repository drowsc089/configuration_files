#!/bin/sh
#chkconfig: 2345 80 05
#description: kibana
 
#export JAVA_HOME=/usr/local/lib/jdk1.8.0_111
#export JAVA_BIN=/usr/local/lib/jdk1.8.0_111/bin
#export PATH=$PATH:$JAVA_HOME/bin
#export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
#export JAVA_HOME JAVA_BIN PATH CLASSPATH
Kibana=/data/kibana
PID=""
 
if [ "$1" = "" ];
then
    echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
    exit 1
fi
 
function query()
{
	PID=`ps aux |grep elk|grep kibana|grep -v $0 | grep -v grep | awk '{print $2}'`
}
 
function start()
{
	query
    
	if [ x"$PID" != x"" ]; then
	    echo "kibana is running..."
	else
		#su elk<<!
		nohup $Kibana/bin/kibana >/data/ELK/kibana_data/logs/start.log 2>&1&
#!
		echo "Start kibana success..."
	fi
}
 
function stop()
{
	echo "Stop kibana"
	query
	echo "WO $PID"
	if [ x"$PID" != x"" ]; then
		kill -TERM $PID
		echo "kibana (pid:$PID) exiting..."
		while [ x"$PID" != x"" ]
		do
			sleep 1
			query
		done
		echo "kibana exited."
	else
		echo "kibana already stopped."
	fi
}
 
function restart()
{
	stop
   	sleep 2
   	start
}
 
case $1 in
start)
    	start;;
stop)
    	stop;;
restart)
		restart;;
*)
 
esac
