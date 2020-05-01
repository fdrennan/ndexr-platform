#' ec2_instance_prebuilt
#' @param ImageId An aws ec2 id: i.e., 'ami-0174e69c12bae5410'
#' @param InstanceType See \url{https://aws.amazon.com/ec2/instance-types/}
#' @param min min instances
#' @param max max instances
#' @param KeyName A .pem file to ssh
#' @param SecurityGroupId SecurityGroupId of security group you have created in UI
#' @param InstanceStorage Size of the box in gb
#' @param postgres_password password for postgres database. username is postgres
#' @param phone_number For notification of completion
#' @param user_data A shell script that runs on startup
#' @param DeviceName  "/dev/sda1"
#' @export ec2_instance_prebuilt
ec2_instance_prebuilt <- function(ImageId = NA,
                                  InstanceType='t2.nano',
                                  min = 1,
                                  max = 1,
                                  KeyName = NA,
                                  SecurityGroupId = NA,
                                  InstanceStorage = 50,
                                  postgres_password = 'password',
                                  phone_number = NA,
                                  DeviceName = "/dev/sda1",
                                  user_data = NA) {
  if(is.na(KeyName)) {
    stop("Please input a KeyName or create one using the AWS UI.")
  }

  if(is.na(SecurityGroupId)) {
    SecurityGroupId <- security_group_create()
    message(SecurityGroupId)
  }

  if(is.na(user_data)) {
    user_data <- ec2_instance_script(postgres_password = postgres_password,
                                     phone_number      = phone_number)
  } else {
    message(user_data)
  }

  ec2_instance_create(
    ImageId = ImageId,
    InstanceType=InstanceType,
    min = min,
    max = max,
    KeyName = KeyName,
    SecurityGroupId = SecurityGroupId,
    InstanceStorage = InstanceStorage,
    DeviceName = DeviceName,
    user_data  = user_data
  )
}
