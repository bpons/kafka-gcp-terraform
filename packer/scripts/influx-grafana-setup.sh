#!/bin/bash
sudo yum -y install wget

wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.8.x86_64.rpm
sudo yum -y localinstall influxdb-1.7.8.x86_64.rpm

sudo yum -y install fontconfig
sudo yum -y install freetype*
sudo yum -y install urw-fonts

wget https://dl.grafana.com/oss/release/grafana-6.4.1-1.x86_64.rpm
sudo yum -y localinstall grafana-6.4.1-1.x86_64.rpm

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server.service

