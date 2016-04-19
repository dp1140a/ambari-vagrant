#!/usr/bin/env bash

cp /vagrant/hosts /etc/hosts
cp /vagrant/resolv.conf /etc/resolv.conf
yum install ntp -y
service ntpd start
service iptables stop
mkdir -p /root/.ssh; chmod 600 /root/.ssh; cp /home/vagrant/.ssh/authorized_keys /root/.ssh/

#Again, stopping iptables
/etc/init.d/iptables stop

# Increasing swap space
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile       none    swap    sw      0       0" >> /etc/fstab

sudo cp /vagrant/insecure_private_key /root/ec2-keypair
sudo chmod 600 /root/ec2-keypair

# Workaround from https://www.digitalocean.com/community/questions/can-t-install-mysql-on-centos-7
rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm

wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.1.1/ambari.repo -O /etc/yum.repos.d/ambari.repo

#Install Ambari-server
yum install ambari-server -y
ambari-server setup -s
ambari-server start

# Install and register ambari agent
yum install ambari-agent -y
sed -i.bak "/^hostname/ s/.*/hostname=$HOSTNAME/" /etc/ambari-agent/conf/ambari-agent.ini
ambari-agent start

cp /vagrant/repos/HDP.repo /etc/yum.repos.d
cp /vagrant/repos/HDP-UTILS.repo /etc/yum.repos.d

#Workaround for AMBARI BUG-41308 http://docs.hortonworks.com/HDPDocuments/Ambari-2.1.1.0/bk_releasenotes_ambari_2.1.0.0/content/ambari_relnotes-2.1.0.0-known-issues.html
yum remove snappy -y
yum install snappy-devel -y