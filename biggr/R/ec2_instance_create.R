#' ec2_instance_create
#' @param ImageId An aws ec2 id: i.e., 'ami-0174e69c12bae5410'
#' @param InstanceType See \url{https://aws.amazon.com/ec2/instance-types/}
#' @param min min instances
#' @param max max instances
#' @param KeyName A .pem file to ssh
#' @param SecurityGroupId SecurityGroupId of security group you have created in UI
#' @param InstanceStorage Size of the box in gb
#' @param user_data A shell script that runs on startup
#' @param DeviceName  "/dev/sda1"
#' @export ec2_instance_create
ec2_instance_create <- function(ImageId = NA,
                                InstanceType='t2.nano',
                                min = 1,
                                max = 1,
                                KeyName = NA,
                                SecurityGroupId = NA,
                                InstanceStorage = 50,
                                DeviceName = "/dev/sda1",
                                user_data  = NA) {

  if(is.na(user_data)) {
    user_data <- ec2_instance_script(null_user = TRUE)
  }

  resource = resource_ec2()
  resource$create_instances(ImageId      = ImageId,
                            InstanceType = InstanceType,
                            MinCount     = as.integer(min),
                            MaxCount     = as.integer(max),
                            UserData     = user_data,
                            KeyName      = KeyName,
                            SecurityGroupIds = list(SecurityGroupId),
                            BlockDeviceMappings = list(
                              list(
                                Ebs = list(
                                  VolumeSize = as.integer(InstanceStorage)
                                ),
                                DeviceName = DeviceName
                              )
                            )
  )

}

