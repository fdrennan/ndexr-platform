library(biggr)
library(tidyverse)

user_data_ami = paste("#!/bin/bash",
                      "echo launch >> /home/ubuntu/notes",
                      sep = "\n")

ec2_instance_create(ImageId = r_box(),
                    KeyName = "Shiny",
                    InstanceStorage = 35L,
                    SecurityGroupId = 'sg-0e8841d7a144aa628',
                    user_data = user_data,
                    InstanceType = 't2.large')

instances <- ec2_instance_info()

public_ip <-
  instances %>%
  filter(launch_time == max(launch_time),
         public_ip_address != "18.217.102.18") %>%
  pull(public_ip_address)
public_ip
public_ip %>%
  str_replace_all("\\.", "\\-") %>%
  paste0('ssh -i "Shiny.pem" ubuntu@ec2-', ., '.us-east-2.compute.amazonaws.com') %>%
  cat

instance_id <-
  instances %>%
  filter(launch_time == max(launch_time),
         public_ip_address != "18.217.102.18") %>%
  pull(instance_id)

