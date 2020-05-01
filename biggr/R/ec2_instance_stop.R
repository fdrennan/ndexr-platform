#' ec2_instance_stop
#' @param ids An aws ec2 id: i.e., 'i-034e6090b1eb879e7'
#' @export ec2_instance_stop
ec2_instance_stop = function(ids) {
  resource = resource_ec2()
  ids = list(ids)
  response <- resource$instances$filter(InstanceIds = ids)$stop()
  if(response[[1]]$ResponseMetadata$HTTPStatusCode == 200) {
    return(TRUE)
  }
}
