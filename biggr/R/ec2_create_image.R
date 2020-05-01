#' @export ec2_create_image
ec2_create_image <- function(image_id, tag_name) {
  boto <- boto3()
  ec2_client <- boto$client("ec2")
  ec2_client$create_image(InstanceId = image_id, Name = tag_name)
}


# ec2_create_image(image_id = 'i-0985a5bef2dcdce91', tag_name = 'testing')
