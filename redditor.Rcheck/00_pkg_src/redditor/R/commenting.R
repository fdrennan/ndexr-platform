#' @export reply_comment
reply_comment <- function(comment_object, body) {
  comment_object$reply(body = body)
}

