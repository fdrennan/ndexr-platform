#' s3_list_buckets
#' @importFrom purrr map_df
#' @importFrom tibble tibble
#' @export s3_list_buckets
s3_list_buckets <- function() {
  s3 = client_s3()
  s3$list_buckets()$Buckets %>%
    map_df(function(x) {
      tibble(name = x$Name,
             creation_date = as.character(x$CreationDate))
    })
}
