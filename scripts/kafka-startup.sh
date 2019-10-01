#!/bin/bash
sudo su

echo "10.1.1.11 zoo1
10.1.1.12 zoo2
10.1.1.13 zoo3" | tee --append /etc/hosts

echo "* hard nofile 100000
* soft nofile 100000" | tee --append /etc/security/limits.conf

echo 'type=83' | sudo sfdisk /dev/sdb
mkfs.xfs -f /dev/sdb
mkdir -p /data/kafka
mount -t xfs /dev/sdb /data/kafka
chown -R kafka:kafka /data/kafka
echo '/dev/sdb /data/kafka xfs defaults 0 0' >> /etc/fstab

sed -i 's/{{broker_id}}/${broker_id}/g' /opt/kafka/config/server.properties

sudo systemctl enable kafka
sudo systemctl start kafka

