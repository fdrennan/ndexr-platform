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
  sudo spark-2.1.0-bin-hadoop2.7/sbin/start-slave.sh spark://18.217.159.13:7077

  sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list'
  gpg --keyserver keyserver.ubuntu.com --recv-key 0x517166190x51716619e084dab9
  gpg -a --export 0x517166190x51716619e084dab9 | sudo apt-key add -
  sudo apt-get update -y

  sudo apt-get install r-base -y
  sudo apt-get install gdebi-core -y

  sudo wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.1335-amd64.deb
  yes | sudo gdebi rstudio-server-1.2.1335-amd64.deb

  sudo apt-get -y install libcurl4-gnutls-dev
  sudo apt-get -y install libssl-dev
  sudo apt-get -y install libxml2-dev

fi

