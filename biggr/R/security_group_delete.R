#' security_group_delete
#' @param security_group_id  a security group ID
#' @export security_group_delete
security_group_delete <- function(security_group_id) {
  client <- client_ec2()
  response = client$delete_security_group(GroupId = security_group_id)
  response$ResponseMetadata$HTTPStatusCode
}

