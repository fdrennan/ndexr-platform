#' s3_put_object_acl
#' @param bucket bucket_name
#' @param file file name
#' @param ACL  permissions type
#' @export s3_put_object_acl
s3_put_object_acl <- function(bucket = NA,
                              file   = NA,
                              ACL    = 'public-read') {

  s3 = client_s3()

  s3$put_object_acl(ACL    ='public-read',
                    Bucket = bucket,
                    Key    = file)
}
