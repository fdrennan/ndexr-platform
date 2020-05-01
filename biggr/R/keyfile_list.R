#' keyfile_list
#' @importFrom purrr map_df
#' @importFrom tibble tibble
#' @export keyfile_list
keyfile_list <- function() {
  key_pair <- client_ec2()
  response <- key_pair$describe_key_pairs()$KeyPairs
  response %>%
    map_df(
      function(x) {
        tibble(
          key_name = x$KeyName,
          fingerprint = x$KeyFingerprint
        )
      }
    )
}
