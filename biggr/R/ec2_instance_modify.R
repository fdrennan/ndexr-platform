#' ec2_instance_modify
#' @param instance_id An aws ec2 id: i.e., 'i-034e6090b1eb879e7'
#' @param attribute  'instanceType',
#' @param value  't2.small'
#' @export ec2_instance_modify
ec2_instance_modify = function(instance_id = NA,
                               attribute = 'instanceType',
                               value     = 't2.small') {

  client <- client_ec2()
  resp <- client$modify_instance_attribute(InstanceId = instance_id,
                                           Attribute  = attribute,
                                           Value      = value)
  if(resp$ResponseMetadata$HTTPStatusCode == 200) {
    return(TRUE)
  }
}

