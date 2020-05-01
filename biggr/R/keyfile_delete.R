#' keyfile_delete
#' @param keyname Keyfile name to deletes
#' @export keyfile_delete
keyfile_delete <- function(keyname = NA) {
  if(is.na(keyname)) {
    stop("Please supply a name for the keyfile")
  }
  key_pair <- client_ec2()
  response <- key_pair$delete_key_pair(KeyName = keyname)
  if(response$ResponseMetadata$HTTPStatusCode == 200) {
    TRUE
  }
}
