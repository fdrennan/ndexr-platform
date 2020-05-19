#' rds_instance_create
#' @param db_instance_identifier  NA,
#' @param allocated_storage  10L,
#' @param database_name  NA,
#' @param engine  "postgres",
#' @param storage_type  "gp2",
#' @param auto_minor_version_upgrade  TRUE,
#' @param multi_az  FALSE,
#' @param master_username  NA,
#' @param master_user_password  NA,
#' @param database_instance_class  "db.t2.micro"
#' @export rds_instance_create
rds_instance_create = function(db_instance_identifier = NA,
                               allocated_storage = 10L,
                               database_name = NA,
                               engine = "../../airflow",
                               storage_type = "gp2",
                               auto_minor_version_upgrade = TRUE,
                               multi_az = FALSE,
                               master_username = NA,
                               master_user_password = NA,
                               database_instance_class = "db.t2.micro") {

  client <- client_rds()

  response <- client$create_db_instance(
    DBInstanceIdentifier    = db_instance_identifier,
    AllocatedStorage        = allocated_storage,
    DBName                  = database_name,
    Engine                  = engine,
    StorageType             = storage_type,
    AutoMinorVersionUpgrade = auto_minor_version_upgrade,
    # Set this to true later?
    MultiAZ                 = multi_az,
    MasterUsername          = master_username,
    MasterUserPassword      = master_user_password,
    DBInstanceClass         = database_instance_class
  )

  response

}




