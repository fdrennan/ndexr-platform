#' ec2_instance_terminate
#' @param ids An aws ec2 id: i.e., 'i-034e6090b1eb879e7'
#' @param force Will ignore question about terminate
#' @export ec2_instance_terminate
ec2_instance_terminate = function(ids, force = FALSE) {
  resource = resource_ec2()
  ids = list(ids)
  if(!force) {
    user_response <-
      readline("Are you sure you want to terminate the instance? All data will be lost. y/n")
    if(user_response != 'y') {
      return(FALSE)
    } else {
      instances = resource$instances
      response <-
        instances$filter(InstanceIds = ids)$terminate()
      return(TRUE)
    }
  } else {
    instances = resource$instances
    response <-
      instances$filter(InstanceIds = ids)$terminate()
    return(TRUE)
  }
}
