#' @export parse_user_token
parse_user_token = function(user_token, secret_id = NULL) {
  token_decoded <- jwt_decode_hmac(user_token, secret_id)
  tibble(
    user_id = token_decoded$user$id,
    initialized_at = token_decoded$iat,
    expires_at = token_decoded$exp
  )
}
