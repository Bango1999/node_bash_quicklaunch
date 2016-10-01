#!/bin/bash

#prereqs, clear logs
echo "Clearing Logs..."
sudo truncate -s 0 /var/log/server.log
sudo truncate -s 0 /var/log/mongo.log
echo "✓"

#start mongodb
echo "Starting Mongo..."
mongo=$(sudo nohup mongod --smallfiles >> /var/log/mongo.log 2>&1 &)
if [[ $? != 0 ]]; then
	echo "Mongo start & log nonzero exit code"
	echo "✗"
	exit 0
elif [[ $mongo ]]; then
	echo "Failed! Error :"
	echo $mongo
	echo "✗"
	exit 0
else
	sleep 1
	mlog=$(tail -5 /var/log/mongo.log | grep "waiting for connections")
	if [[ $mlog ]]; then
		echo $mlog
	else
		echo "ERROR! :"
		echo "#####################"
		tail -3 /var/log/mongo.log
		echo "#####################"
		echo "✗"
		exit 0
	fi
fi
echo "✓"

#start node.js
echo "Starting Node..."
node=$(sudo nohup node /var/www/portfolio/app.js >> /var/log/server.log 2>&1 &)
if [[ $? != 0 ]]; then
	echo "Node start & log nonzero exit code"
	sudo mongod --shutdown
	echo "✗"
	exit 0
elif [[ $node ]]; then
	echo "Failed! Error :"
	echo $node
	echo "✗"
	exit 0
else
	sleep 1
	log=$(tail -5 /var/log/server.log | grep "listening on port")
	if [[ $log ]]; then
		echo $log
	else
		echo "ERROR! :"
		echo "#####################"
		tail -3 /var/log/server.log
		echo "#####################"
		echo "Shutting down MongoDB..."
		sudo mongod --shutdown
		echo "Exiting Gracefully. Good luck."
		echo "✗"
		exit 0
	fi
fi

dt=$(date '+%d/%m/%Y %H:%M');
echo $dt > /var/local/tmp/date.time
echo "✓"
exit 0
