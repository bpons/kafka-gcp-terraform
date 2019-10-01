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