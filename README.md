# Ambari on Vagrant

This project was blantantly copied form the [sequenceiq/ambari-vagrant](https://github.com/sequenceiq/ambari-vagrant) project.  Which i turn was copied from the Apache Ambari [Quick Start Guide](https://cwiki.apache.org/confluence/display/AMBARI/Quick+Start+Guide) and modified. I have added in the ability to spin up a single node Ambari 2.2.1 and HDP 2.4 cluster on CentOS7.0 with the following services:

* HDFS
* Yarn
* MapReduce
* Zookeeper

I have trimmed all the other operating systems form the original project.  As of now this will spin up nodes only on CentOS7.x

## Requirements

You need [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/)

## Staring Up

Starts up 1 node (c7001) by default.  It will set the correct repos for Ambari and HDP, download, install and startup ambari-server.  It will also install ambari-agent on the host.  Additioanlly it will also install snappy-devel to get around [AMBARI BUG-41308]( http://docs.hortonworks.com/HDPDocuments/Ambari-2.1.1.0/bk_releasenotes_ambari_2.1.0.0/content/ambari_relnotes-2.1.0.0-known-issues.html)
```
git clone https://github.com/dp1140a/ambari-vagrant.git
cd ambari-vagrant
vagrant up c7001
```

## Deploy cluster
Once the server is up and running you can build and deploy your cluster with the following:
```
curl -i -u admin:admin -H "X-Requested-By: ambari" -X POST -d @blueprints/baseStack.json http://c7001.ambari.apache.org:8080/api/v1/blueprints/baseStack

curl -i -u admin:admin -H "X-Requested-By: ambari" -X POST -d @blueprints/createBaseStack.json http://c7001.ambari.apache.org:8080/api/v1/clusters/MySingleNodeCluster
```

The blueprints are in the "blueprints" folder and can be modified to your liking.  Other blueprint examples can be found [here](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints)
