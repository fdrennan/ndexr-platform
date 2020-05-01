#' spark_master
#' @param InstanceType 't2.medium'
#' @param KeyName = NA
#' @param SecurityGroupId = NA
#' @param InstanceStorage = 50
#' @export spark_master
spark_master <- function(
  InstanceType='t2.medium',
  KeyName = NA,
  SecurityGroupId = NA,
  InstanceStorage = 50
) {

  running_instances <- ec2_instance_info()

  user_data_ami = paste("#!/bin/bash",
                        "/home/ubuntu/spark-2.1.0-bin-hadoop2.7/sbin/start-master.sh",
                        sep = "\n")

  ec2_instance_create(ImageId = r_box(),
                      KeyName = KeyName,
                      InstanceStorage = InstanceStorage,
                      SecurityGroupId = SecurityGroupId,
                      user_data = user_data_ami,
                      InstanceType = InstanceType)


  updated_running_instances <- ec2_instance_info()

  master_data <- filter(
    updated_running_instances,
    !updated_running_instances$instance_id %in% running_instances$instance_id
  )

  master_data
}
