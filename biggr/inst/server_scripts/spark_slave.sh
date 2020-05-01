#!/bin/bash
echo 'Successully started' >> /notes

install_data=true
if [ "$install_data" = true ]; then
  sudo apt-get update -y
  sudo apt-get update --fix-missing
  sudo apt install default-jre -y
  sudo apt install default-jdk -y
  wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
  tar -xvzf spark-2.1.0-bin-hadoop2.7.tgz
  sudo spark-2.1.0-bin-hadoop2.7/sbin/start-slave.sh spark://3.14.249.18:7077
fi

