#!/bin/bash
sudo yum -y install wget

wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.8.x86_64.rpm
sudo yum -y localinstall influxdb-1.7.8.x86_64.rpm


