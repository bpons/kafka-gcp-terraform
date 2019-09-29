echo "10.1.1.11 zoo1
10.1.1.12 zoo2
10.1.1.13 zoo3" | sudo tee --append /etc/hosts

echo ${id} > /var/lib/zookeeper/myid
sudo chown ubuntu:ubuntu /var/lib/zookeeper/myid

sudo systemctl enable zk
sudo systemctl start zk