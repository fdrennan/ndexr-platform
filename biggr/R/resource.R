
#' resource_ec2
#' @export resource_ec2
resource_ec2 <- function() {
  boto$resource("ec2")
}

#' resource_s3
#' @export resource_s3
resource_s3 <- function() {
  boto$resource("s3")
}
