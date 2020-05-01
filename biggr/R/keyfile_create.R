#' keyfile_create
#' @importFrom utils write.table
#' @param keyname name for keyfile
#' @param save_to_directory save to working directory
#' @export keyfile_create
keyfile_create <- function(keyname = NA, save_to_directory = TRUE) {
  if(is.na(keyname)) {
    stop("Please supply a name for the keyfile")
  }
  key_pair <- client_ec2()$create_key_pair(KeyName=keyname)
  db_store_keyfile(
    keyname,
    key_pair$KeyMaterial
  )
  # if(save_to_directory) {
  #   filename = paste0(keyname, ".pem")
  #   write.table(key_pair$KeyMaterial,
  #               file = filename,
  #               row.names = FALSE,
  #               col.names = FALSE,
  #               quote = FALSE)
  #   set_permissions = paste("chmod 400", filename)
  #   system(set_permissions)
  # }
  key_pair$KeyMaterial
}
