#!/bin/bash
echo 'Successully started' >> /notes
wget https://s3.us-east-2.amazonaws.com/shellscriptsfdrennan/jdk-8u211-linux-x64.tar.gz
wget https://s3.us-east-2.amazonaws.com/shellscriptsfdrennan/libcudnn7_7.5.1.10-1%2Bcuda9.0_amd64.deb
sudo mkdir /usr/java/
cd /usr/java
sudo tar zxvf /home/ubuntu/jdk-8u211-linux-x64.tar.gz
sudo echo '' >> /etc/environment
# export JAVA_HOME=/usr/java/jdk1.8.0_211
# PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# PATH=$PATH:$JAVA_HOME/bin
# .basrc  SPARK_HOME=/home/ubuntu/spark-2.1.0-bin-hadoop2.7

# wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
# tar -xvzf spark-2.1.0-bin-hadoop2.7.tgz
# # cd spark-2.1.0-bin-hadoop2.7

# wget https://s3.us-east-2.amazonaws.com/shellscriptsfdrennan/jdk-8u211-linux-x64.tar.gz
# mkdir /usr/java
# cp jdk-8u211-linux-x64.tar.gz /usr/javajdk-8u211-linux-x64.tar.gz
# tar zxvf /usr/javajdk-8u211-linux-x64.tar.gz
#
# install_data=true
# if [ "$install_data" = true ]; then
#   cd /home/ubuntu
#   echo 'deb https://cloud.r-project.org/bin/linux/ubuntu disco-cran35/' >> /etc/apt/sources.list
#   sudo apt-get update -y
#   sudo apt-get update --fix-missing
#   sudo apt install default-jre -y
#   sudo apt install default-jdk -y
#   wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
#   tar -xvzf spark-2.1.8680-bin-hadoop2.7.tgz
#   mv spark-2.1.0-bin-hadoop2.7 /usr/local/spark
#
#   echo 'Installing R' >> /notes
#   sudo apt-get install r-base -y
  # sudo apt-get install libcurl4-openssl-dev -y
  # sudo apt-get install libgit2-dev -y
  # sudo apt-get install libssl-dev -y
  # sudo apt-get install libssh2-1-dev -y
    # sudo apt-get install libgit2-dev
#   sudo apt-get install gdebi-core
  # sudo apt-get install libpq-dev -y
  # sudo apt-get install libxml2-dev -y
#
#   echo 'Installing RStudio Server' >> /notes
  # sudo wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.1335-amd64.deb
  # yes | sudo gdebi rstudio-server-1.2.1335-amd64.deb
#
#   chmod 777 /usr/local/lib/R/site-library
#
#   echo 'Installing Shiny' >> /notes
#   sudo su - ubuntu \
#     -c "R -e \"install.packages('sparklyr', repos='https://cran.rstudio.com/')\""
#
#   sudo su - ubuntu \
#     -c "R -e \"library(sparklyr); spark_install()\""
#
#   echo 'export PATH=$PATH:/home/ubuntu/spark/spark-2.4.0-bin-hadoop2.7/bin' >> /home/ubuntu/.bashrc
#
#   source /home/ubuntu/.bashrc
#
# fi
#
#
#
#
