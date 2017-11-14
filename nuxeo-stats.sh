#!/bin/bash
# Nuxeo Reporting Script

#################################################
#
# Requires $NUXEO_HOME to be set
# Assumes ES is @ 9200
# Assumes JMX is @ 1089
# Requires redis-cli to be installed
# Requires stats-tmp dir inside of ~/tmp
#
#################################################

mkdir ~/tmp
mkdir ~/tmp/stats-tmp

# General Nuxeo Status and Configuration
$NUXEO_HOME/bin/nuxeoctl showconf > ~/tmp/stats-tmp/nuxeo-conf.log
$NUXEO_HOME/bin/nuxeoctl status > ~/tmp/stats-tmp/nuxeo-status.log

# CPU Activity
top -bcH -n1 -w512 > ~/tmp/stats-tmp/nuxeo-top.log

# JVM Thread Dump
jcmd Bootstrap Thread.print > ~/tmp/stats-tmp/thread-dmp-1.log
sleep 20
jcmd Bootstrap Thread.print > ~/tmp/stats-tmp/thread-dmp-2.log
sleep 20
jcmd Bootstrap Thread.print > ~/tmp/stats-tmp/thread-dmp-3.log

# JVM Core Dump
#echo 'JVM Core Dump' >> tmp/nuxeo-stats.log
#sudo gdb --pid=<PID> --batch -ex generate-core-file -ex detach >> tmp/nuxeo-stats.log

# JVM Flight Recording
jcmd Bootstrap JFR.start duration=60s filename=~/tmp/stats-tmp/flight-recording.log 

# ES
curl "localhost:9200" > ~/tmp/stats-tmp/nuxeo-stats-ES.log
curl "localhost:9200/_cat/health?v" > ~/tmp/stats-tmp/nuxeo-stats-ES-health.log
curl "localhost:9200/_cat/nodes?v" > ~/tmp/stats-tmp/nuxeo-stats-ES-nodes.log
curl "localhost:9200/_cat/indices?v" > ~/tmp/stats-tmp/nuxeo-stats-ES-indices.log

# JMX Metrics
# download jmxterm
wget http://sourceforge.net/projects/cyclops-group/files/jmxterm/1.0-alpha-4/jmxterm-1.0-alpha-4-uber.jar/download -O ~/tmp/stats-tmp/jmxterm-1.0-alpha-4-uber.jar
# list metrics beans and create a script
echo -e "domain metrics\nbeans" | java -jar ~/tmp/stats-tmp/jmxterm-1.0-alpha-4-uber.jar -l localhost:1089 -n | sed -e "s,^,get -b ,g" -e "s,$, \*,g" >> ~/tmp/stats-tmp/metrics-script.txt
# get metrics info
(date +'%Y-%m-%d %H:%M:%S:%3N'; java -jar ~/tmp/stats-tmp/jmxterm-1.0-alpha-4-uber.jar -l localhost:1089 -n -i ~/tmp/stats-tmp/metrics-script.txt)  > ~/tmp/stats-tmp/metrics.txt 2>&1

# Garbage Collection in gc.log
cp $NUXEO_HOME/log/gc.log ~/tmp/stats-tmp/gc.log

# Redis CLI
redis-cli | INFO > ~/tmp/stats-tmp/redis.log

# Server Log
cp $NUXEO_HOME/log/server.log ~/tmp/stats-tmp/server.log

cd ~/tmp/stats-tmp

zip -r metrics-results.zip ./*
