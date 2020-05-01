#' spark_slave
#' @param InstanceType 't2.medium'
#' @param KeyName = NA
#' @param SecurityGroupId = NA
#' @param InstanceStorage = 50
#' @param n_instances = 2
#' @param master_ip = NULL
#' @export spark_slave
spark_slave <- function(
  InstanceType='t2.medium',
  KeyName = NA,
  SecurityGroupId = NA,
  InstanceStorage = 50,
  n_instances = 2,
  master_ip = NULL
) {

  running_instances <- ec2_instance_info()

  user_data_ami = paste("#!/bin/bash",
                        paste0("/home/ubuntu/spark-2.1.0-bin-hadoop2.7/sbin/start-slave.sh ", master_ip, ":7077"),
                        sep = "\n")

  for(instance in 1:n_instances) {
    ec2_instance_create(ImageId = r_box(),
                        KeyName = KeyName,
                        InstanceStorage = InstanceStorage,
                        SecurityGroupId = SecurityGroupId,
                        user_data = user_data_ami,
                        InstanceType = InstanceType)
  }

  updated_running_instances <- ec2_instance_info()

  slave_data <- filter(
    updated_running_instances,
    !updated_running_instances$instance_id %in% running_instances$instance_id
  )

  slave_data
}
