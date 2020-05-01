#' \code{awsR} package
#'
#' Google spreadsheets R API
#' @docType package
#' @name awsR
#' @importFrom dplyr %>%
#' @importFrom purrr %||%
NULL

## quiets concNoerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  {
  utils::globalVariables(
    c(
      ".",  "Key", "Size", "ETag", "StorageClass", "Owner.ID", "LastModified", "Keep",
      "group_name", "group_id"
    )
  )
}
