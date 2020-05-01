#' ec2_instance_start
#' @param instance_id An aws ec2 id: i.e., 'i-034e6090b1eb879e7'
#' @export ec2_instance_start
ec2_instance_start = function(instance_id = NA) {
  client <- client_ec2()
  response <- client$start_instances(InstanceIds = list(instance_id))
  if(response$ResponseMetadata$HTTPStatusCode == 200) {
    return(TRUE)
  }
}



