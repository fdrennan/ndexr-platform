#' ec2_image_create
#' @param name A name for the imange
#' @param instance_id And instance Id
#' @export ec2_image_create
ec2_image_create <- function(
  name = NA,
  instance_id = NA
) {
  bot <- boto3()
  client <- client_ec2()
  client$create_image(Name = name,
                      InstanceId = instance_id)
}

