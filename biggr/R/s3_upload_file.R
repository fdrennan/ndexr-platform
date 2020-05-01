#' upload_file
#' @param bucket Bucket to upload to
#' @param from File to upload
#' @param to S3 object name.
#' @param make_public boolean
#' @param region To create url for file
#' @export s3_upload_file
s3_upload_file <- function(bucket,
                           from,
                           to,
                           make_public = FALSE,
                           region = "us-east-2") {

  s3 = client_s3()

  s3$upload_file(Filename = from,
                 Bucket   = bucket,
                 Key      = to)

  if(make_public) {
    s3_put_object_acl(bucket = bucket, file = to)
  }


  message(
    paste(
      "You may need to change the region in the url",
      paste0('https://s3.', region,'.amazonaws.com/', bucket,'/', to),
      sep = "\n"
    )
  )

  paste0('https://s3.us-east-2.amazonaws.com/', bucket,'/', to)

}
