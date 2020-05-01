#' if_is_null
#' @param x  input
#' @export if_is_null
if_is_null <- function(x) {
  if_else(is.null(x), as.character(NA), x)
}

#' rand_name
#' @export rand_name
rand_name <- function() {
  paste0(
    'randfile',
    paste(sample(1:100, 5), collapse = "")
  )
}
