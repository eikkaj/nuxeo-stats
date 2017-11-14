# nuxeo-stats

** Shell Script for Producing Important Nuxeo server metrics **

## About
This is a basic shell script that could be useful for gathering metrics for Nuxeo server reporting

## Usage
./nuxeo-stats

### Requirements
Script as-is requires the following:
- $NUXEO_HOME to be set
- /var/log/nuxeo/ to be dir with nuxeo logs
- ElasticSearch at port 9200
- JMX at port 1089
- redis-cli
