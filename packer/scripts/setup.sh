echo 'vm.swappiness=1' | sudo tee --append /etc/sysctl.conf

sudo apt-get update && \
      sudo apt-get -y install ca-certificates zip net-tools netcat

sudo apt-get -y install openjdk-8-jdk

wget https://www-us.apache.org/dist/zookeeper/stable/apache-zookeeper-3.5.5-bin.tar.gz  
tar -xvzf apache-zookeeper-3.5.5-bin.tar.gz  
rm apache-zookeeper-3.5.5-bin.tar.gz

sudo mv apache-zookeeper-3.5.5-bin zookeeper
sudo mv zookeeper /opt

sudo mkdir /var/lib/zookeeper
sudo chown ubuntu:ubuntu /var/lib/zookeeper

sudo mv /home/ubuntu/zoo.cfg /opt/zookeeper/conf/zoo.cfg
sudo chown ubuntu:ubuntu /opt/zookeeper/conf/zoo.cfg

sudo mv /home/ubuntu/zk.service /etc/systemd/system/zk.service
sudo chown ubuntu:ubuntu /etc/systemd/system/zk.service



