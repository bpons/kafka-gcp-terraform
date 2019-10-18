#!/bin/bash
sudo yum -y install wget

sudo yum -y install fontconfig
sudo yum -y install freetype*
sudo yum -y install urw-fonts

wget https://dl.grafana.com/oss/release/grafana-6.4.1-1.x86_64.rpm
sudo yum -y localinstall grafana-6.4.1-1.x86_64.rpm
