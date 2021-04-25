#!/bin/sh
#chkconfig: 2345 80 05
#description: logstash
 
source /etc/profile

#export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.272.b10-1.el7_9.x86_64/jre
#export JAVA_BIN=${JAVA_HOME}/bin
#export PATH=$PATH:$JAVA_HOME/bin
#export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
#export JAVA_HOME JAVA_BIN PATH CLASSPATH
logstash=/data/ELK/logstash
PID=""
 
if [ "$1" = "" ];
then
    echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
    exit 1
fi
 
function query()
{
	PID=`ps aux |grep elk|grep logstash|grep -v $0 | grep -v grep | awk '{print $2}'`
}
 
function start()
{
	query
    
	if [ x"$PID" != x"" ]; then
	    echo "logstash is running..."
	else
		#su elk<<!
		nohup $logstash/bin/logstash -f $logstash/config/conf.d/logstash_kafka_to_es.conf > /dev/null 2>&1 &
#!
		echo "Start logstash success..."
	fi
}
 
function stop()
{
	echo "Stop logstash"
	query
	echo "WO $PID"
	if [ x"$PID" != x"" ]; then
		kill -TERM $PID
		echo "logstash (pid:$PID) exiting..."
		while [ x"$PID" != x"" ]
		do
			sleep 1
			query
		done
		echo "logstash exited."
	else
		echo "logstash already stopped."
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
