#!/bin/bash

yum -y install wget
wget 'https://github.com/prometheus/prometheus/releases/download/v2.7.2/prometheus-2.7.2.linux-amd64.tar.gz'
tar xvfz prometheus-*.tar.gz
cd prometheus-*

cat << HERE > prometheus-config.yml
${prometheus_config}
HERE

./prometheus --config.file=prometheus-config.yml &