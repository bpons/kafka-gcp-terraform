#!/bin/bash
sudo yum -y install wget
sudo yum -y install java-1.8.0-openjdk

wget https://www.apache.org/dist/kafka/2.3.0/kafka_2.12-2.3.0.tgz

tar -xvf kafka_2.12-2.3.0.tgz
rm kafka_2.12-2.3.0.tgz
mv kafka_2.12-2.3.0 kafka
sudo mv kafka /opt

mv /home/kafka/server.properties /opt/kafka/config/server.properties

sudo mv /home/kafka/kafka.service /etc/systemd/system/kafka.service
sudo chown kafka:kafka /etc/systemd/system/kafka.service

wget https://dl.influxdata.com/telegraf/releases/telegraf-1.12.3-1.x86_64.rpm
sudo yum -y localinstall telegraf-1.12.3-1.x86_64.rpm
rm telegraf-1.12.3-1.x86_64.rpm
sudo mv /home/kafka/telegraf.conf /etc/telegraf/telegraf.conf
sudo mv /home/kafka/system.conf /etc/telegraf/telegraf.d/system.conf
sudo mv /home/kafka/jolokia.conf /etc/telegraf/telegraf.d/jolokia.conf

wget https://github.com/rhuss/jolokia/releases/download/v1.6.2/jolokia-1.6.2-bin.tar.gz
sudo mkdir /opt/jolokia-1.6.2
sudo chown kafka:kafka /opt/jolokia-1.6.2
tar -xvf jolokia-1.6.2-bin.tar.gz -C /opt
rm jolokia-1.6.2-bin.tar.gz

sudo sed -i '/^exec $base_dir\/kafka-run-class.sh.*/i export KAFKA_OPTS="-javaagent:\/opt\/jolokia-1.6.2\/agents\/jolokia-jvm.jar=port=7777,host=0.0.0.0"' /opt/kafka/bin/kafka-server-start.sh
