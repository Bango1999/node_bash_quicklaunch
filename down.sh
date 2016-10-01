#!/bin/bash
echo Server Kill Switch Engaged. Halting...
sudo killall node
sudo mongod --shutdown

#dramatic server temination
read birth < /var/local/tmp/date.time
sudo truncate -s 0 /var/local/tmp/date.time
death=$(date '+%d/%m/%Y %H:%M')
epitaph="RIP Server
$birth - $death"
echo ""
echo "$epitaph"
