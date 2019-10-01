#!/bin/bash

sudo yum -y install wget
sudo yum -y install java-1.8.0-openjdk

wget https://www-us.apache.org/dist/zookeeper/stable/apache-zookeeper-3.5.5-bin.tar.gz  
tar -xvzf apache-zookeeper-3.5.5-bin.tar.gz  
rm apache-zookeeper-3.5.5-bin.tar.gz

sudo mv apache-zookeeper-3.5.5-bin zookeeper
sudo mv zookeeper /opt

sudo mkdir /var/lib/zookeeper
sudo chown zk:zk /var/lib/zookeeper

sudo mv /home/zk/zoo.cfg /opt/zookeeper/conf/zoo.cfg
sudo chown zk:zk /opt/zookeeper/conf/zoo.cfg

sudo mv /home/zk/zk.service /etc/systemd/system/zk.service
sudo chown zk:zk /etc/systemd/system/zk.service

echo 'vm.swappiness=1' | sudo tee --append /etc/sysctl.conf