#!/bin/bash

sudo yum -y install wget
sudo yum -y install java-1.8.0-openjdk

wget https://www-us.apache.org/dist/zookeeper/zookeeper-3.5.5/apache-zookeeper-3.5.5-bin.tar.gz  
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

wget https://dl.influxdata.com/telegraf/releases/telegraf-1.12.3-1.x86_64.rpm
sudo yum -y localinstall telegraf-1.12.3-1.x86_64.rpm
rm telegraf-1.12.3-1.x86_64.rpm
sudo mv /home/zk/telegraf.conf /etc/telegraf/telegraf.conf
sudo mv /home/zk/system.conf /etc/telegraf/telegraf.d/system.conf
sudo mv /home/zk/jolokia.conf /etc/telegraf/telegraf.d/jolokia.conf


wget https://github.com/rhuss/jolokia/releases/download/v1.6.2/jolokia-1.6.2-bin.tar.gz
sudo mkdir /opt/jolokia-1.6.2
sudo chown zk:zk /opt/jolokia-1.6.2
tar -xvf jolokia-1.6.2-bin.tar.gz -C /opt
rm jolokia-1.6.2-bin.tar.gz

echo '
export JOLOKIA="-javaagent:/opt/jolokia-1.6.2/agents/jolokia-jvm.jar=port=7777,host=0.0.0.0"
export SERVER_JVMFLAGS="$SERVER_JVMFLAGS $JOLOKIA"
' >> /opt/zookeeper/bin/zkEnv.sh
