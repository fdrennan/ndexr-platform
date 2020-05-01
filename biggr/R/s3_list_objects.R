#' s3_list_objects
#' @param bucket_name bucket_name
#' @importFrom dplyr if_else
#' @importFrom dplyr transmute
#' @importFrom purrr map_df
#' @importFrom tibble tibble
#' @importFrom tibble as_tibble
#' @export s3_list_objects
s3_list_objects <- function(bucket_name = NA) {

  s3 = client_s3()

  results <-
    s3$list_objects(Bucket=bucket_name)

  if(is.null(results$Contents)) {
    return(FALSE)
  }

  results$Contents %>%
    map_df(function(x) {
      as.data.frame(lapply(unlist(x), as.character))
    }) %>%
    transmute(
      key = as.character(Key),
      size = as.character(Size),
      etag = as.character(ETag),
      storage_class = as.character(StorageClass),
      owner_id = as.character(Owner.ID),
      last_modified = as.character(LastModified)
    ) %>%
    as_tibble
}

