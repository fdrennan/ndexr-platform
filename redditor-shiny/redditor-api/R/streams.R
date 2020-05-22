#' @export stream_comments
stream_comments <- function(reddit, subreddit, callback) {
  stream <- reddit$subreddit(subreddit)
  iterate(stream$stream$comments(), callback)
}


#' @export stream_submission
stream_submission <- function(reddit, subreddit, callback) {
  stream <- reddit$subreddit(subreddit)
  iterate(stream$stream$submissions(), callback)
}

#' #' @export parse_comment_stream
#' parse_submission_stream <- function(x) {
#'   key_value_pairs <- map(names(x), ~ list(key = ., value = as.character(x[.])))
#'   response <- keep(
#'     key_value_pairs, function(x) {
#'       condition_1 <- length(x$value) > 0
#'       condition_2 <- !str_detect(x$value, 'bound method')
#'       condition_3 <- !str_detect(x$value, 'praw.models')
#'       condition_4 <- !str_detect(x$value, 'function Comment.')
#'       all(condition_1, condition_2, condition_3, condition_4)
#'     }
#'   )
#'   keys <- map_chr(response, function(x) {x$key})
#'   values <- map_chr(response, function(x) {x$value})
#'   response <- as_tibble(t(tibble(values = values)), .name_repair = 'minimal')
#'   names(response) = keys
#'   response
#' }
