#' s3_delete_file
#' @param bucket Bucket to upload to
#' @param file File to delete
#' @export s3_delete_file
s3_delete_file <- function(bucket,
                           file) {

  s3 = client_s3()

  response <-
    s3$delete_object(Bucket   = bucket,
                     Key      = file)

  if(response$ResponseMetadata$HTTPStatusCode == 204) {
    TRUE
  }

}
