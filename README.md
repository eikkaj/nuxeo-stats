# nuxeo-stats

** Shell Script for Producing Important Nuxeo server metrics **

## About
This is a basic shell script that could be useful for gathering metrics for Nuxeo server reporting. 
The following reports are built and then conveniently zipped automatically:
- Nuxeo Configuration: nuxeoctl showconf
- Nuxeo Status: nuxeoctl status
- CPU Processes: top -bcH -n1 -w512
- JVM Threads: jcmd Bootstrap Thread.print
- JVM Flight Recording: jcmd Bootstrap JFR.start duration=60s
- ElasticSearch Metrics
- JMX Metrics
- Copy Garbage Collection logs
- Copy Nuxeo server logs
- redis-cli INFO

## Usage
./nuxeo-stats

### Requirements
Script as-is requires the following:
- $NUXEO_HOME to be set
- /var/log/nuxeo/ to be dir with nuxeo logs
- ElasticSearch at port 9200
- JMX at port 1089
- redis-cli

