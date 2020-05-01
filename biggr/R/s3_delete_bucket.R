#' s3_create_bucket
#' @param bucket_name A name for the bucket
#' @export s3_delete_bucket
s3_delete_bucket <- function(bucket_name = NA) {
  s3 = client_s3()
  response <-
    try(s3$delete_bucket(Bucket = bucket_name))
  if(
    response$ResponseMetadata$HTTPStatusCode == 204
  ) {
    return(TRUE)
  }
}

