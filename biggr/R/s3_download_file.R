#' s3_download_file
#' @param bucket Bucket to upload to
#' @param from S3 object name.
#' @param to File path
#' @export s3_download_file
s3_download_file <- function(bucket, from, to) {

  s3 = client_s3()
  s3$download_file(Bucket = bucket,
                   Filename = to,
                   Key = from)

  TRUE
}
