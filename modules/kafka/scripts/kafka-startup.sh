#!/bin/bash
sudo su

echo "* hard nofile 100000
* soft nofile 100000" | tee --append /etc/security/limits.conf

echo 'type=83' | sudo sfdisk /dev/sdb
mkfs.xfs -f /dev/sdb
mkdir -p /data/kafka
echo '/dev/sdb /data/kafka xfs user,defaults 0 0' >> /etc/fstab
mount -a
chown -R kafka:kafka /data/kafka

sed -i 's/{{broker_id}}/${broker_id}/g' /opt/kafka/config/server.properties

systemctl enable kafka
systemctl start kafka

