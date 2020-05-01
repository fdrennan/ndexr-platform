# devtools::install_github("fdrennan/biggr")

library(biggr)
library(reticulate)
library(tidyverse)
# install_python(envname = 'biggr')
use_virtualenv('biggr')
# configure_aws(
#   aws_access_key_id     = "XXXX",
#   aws_secret_access_key = "XXX",
#   default.region        = "us-east-2"
# )

master_data <- spark_master(
  KeyName = "Shiny",
  InstanceStorage = 35L,
  SecurityGroupId = 'sg-0e8841d7a144aa628',
  InstanceType = 't2.medium'
)

slave_data <- spark_slave(
  KeyName = "Shiny",
  InstanceStorage = 35L,
  SecurityGroupId = 'sg-0e8841d7a144aa628',
  InstanceType = 't2.medium',
  n_instances = 3,
  master_ip = master_data$public_ip_address
)

slave_data$public_ip_address[1] %>%
  str_replace_all("\\.", "\\-") %>%
  paste0('ssh -i "Shiny.pem" ubuntu@ec2-', ., '.us-east-2.compute.amazonaws.com') %>%
  cat

master_data$public_ip_address

if(TRUE) {
  for(i in c(master_data$instance_id, slave_data$instance_id)) {
    print(i)
    ec2_instance_terminate(i, force = TRUE)
  }
}









