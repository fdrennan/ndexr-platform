#' s3_create_bucket
#' @param bucket_name A name for the bucket
#' @param location An AWS region. Defaults to us-east-2
#' @export s3_create_bucket
s3_create_bucket <- function(bucket_name = NA, location = 'us-east-2') {
  message(
    'Bucket name should conform with DNS requirements:
    - Should not contain uppercase characters
    - Should not contain underscores (_)
    - Should be between 3 and 63 characters long
    - Should not end with a dash
    - Cannot contain two, adjacent periods
    - Cannot contain dashes next to periods (e.g., "my-.bucket.com" and "my.-bucket" are invalid)'
  )
  s3 = client_s3()
  response <-
    s3$create_bucket(Bucket=bucket_name,
                     CreateBucketConfiguration=list(LocationConstraint= location))

  response$Location

}
