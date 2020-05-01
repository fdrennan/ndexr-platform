#' @export db_store_keyfile
db_store_keyfile <- function(key_file_name, keyfile) {
  keyfile_tibble = tibble(
    created_at = Sys.time(),
    key_file_name = key_file_name,
    keyfile = keyfile
  )
  con = postgres_connector()
  on.exit(dbDisconnect(con))

  table_name = 'keyfiles'
  missing_table <- !table_name %in% dbListTables(conn = con)

  if (missing_table) {
    dbCreateTable(conn = con, table_name, keyfile_tibble)
  }

  dbAppendTable(
    conn = con,
    name = table_name,
    value = keyfile_tibble
  )
}


#' @export db_create_instance
db_create_instance <- function(dataframe, user_token_data) {

  con = postgres_connector()
  on.exit(dbDisconnect(con))

  table_name = 'instance_created'
  missing_table <- !table_name %in% dbListTables(conn = con)

  if (missing_table) {
    dbCreateTable(conn = con, table_name, dataframe)
  }

  dbAppendTable(
    conn = con,
    name = table_name,
    value = dataframe
  )
}


#' @export db_instance_status
db_instance_status = function(id, status) {

  con = postgres_connector()
  on.exit(dbDisconnect(con))
  table_name = 'instance_status'
  missing_table <- !table_name %in% dbListTables(conn = con)

  update_data <- data.frame(
    id = id,
    status = status,
    time = now(tzone = 'UTC')
  )

  if (missing_table) {
    dbCreateTable(conn = con, table_name, update_data)
  }


  dbAppendTable(
    conn = con,
    name = table_name,
    value = update_data
  )
}




#' @export api_instance_start
api_instance_start <- function(user_token = user_token,
                               token_secret = NULL,
                               instance_type = NULL,
                               key_name = NULL,
                               image_id = 'ami-0fc20dd1da406780b',
                               security_group_id = 'sg-0221bdbcdc66ac93c',
                               security_group_name = NA,
                               instance_storage = 50,
                               to_json = TRUE) {

  user_token_data <- parse_user_token(user_token, token_secret)

  if (image_id == 'ami-0fc20dd1da406780b') {
    use_data <-
      paste( '#!/bin/bash',
             'cd /home/ubuntu',
             'wget https://s3.us-east-2.amazonaws.com/ndexr-files/startup.sh -P /home/ubuntu',
             'su ubuntu -c \'. /home/ubuntu/startup.sh &\'',
             # Something else
             sep = "\n")
  } else {
    use_data <-
      paste( '#!/bin/bash',
           'echo hello >> /home/ubuntu/hello.txt',
           'wget https://s3.us-east-2.amazonaws.com/ndexr-files/parallel.R -P /home/ubuntu/',
           'mkdir /home/ubuntu/gpu_docker',
           'wget https://s3.us-east-2.amazonaws.com/ndexr-files/ndexr-gpu -O /home/ubuntu/gpu_docker/Dockerfile',
           'cd /home/ubuntu/gpu_docker && docker build -t rockerpy .',
           'docker run --gpus all -e PASSWORD=thirdday1 -p 8788:8787 rockerpy',
           # Something else
           sep = "\n")
  }

  if(!is.na(security_group_name)) {
    security_group_id = filter(security_group_list(), group_name == security_group_name)$group_id
    if(length(security_group_id) == 0) {
      stop('Incorrect security group name given.')
    }
  }

  resp <-
    ec2_instance_create(ImageId = image_id,
                        InstanceType = instance_type,
                        KeyName = key_name,
                        SecurityGroupId = security_group_id,
                        InstanceStorage = instance_storage,
                        user_data = use_data)

  data_tibble <-
    tibble(
      user_id = user_token_data$user_id,
      creation_time = Sys.time(),
      id = resp[[1]]$id,
      key_name = key_name,
      instance_type = instance_type,
      image_id = image_id,
      security_group_id = security_group_id,
      instance_storage = instance_storage
    )

  db_create_instance(data_tibble, user_token_data)
  db_instance_status(resp[[1]]$id, 'start')

  data_tibble


}


#' @export modify_instance
modify_instance <- function(id = NULL, method = NULL, instance_type = NULL) {
  if (is.null(id)) {
    stop('Must supply an instance id')
  }

  if (is.null(method) | !(method %in% c('start', 'stop', 'reboot', 'terminate', 'modify'))) {
    stop('Must supply an instance modification method: start, stop, reboot, terminate, modify')
  }

  switch(
    method,
    'start' = {
      tryCatch({
        ec2_instance_start(instance_id = id)
        db_instance_status(id = id, status = method)
        return('Instance started')
      },
      error = function(err) {
        stop(err)
      })
    },
    'stop' = {
      tryCatch({
        ec2_instance_stop(ids = id)
        db_instance_status(id = id, status = method)
        return('Instance stopping')
      },
      error = function(err) {
        stop(err)
      })
    },

    'reboot' = {
      tryCatch({
        ec2_instance_reboot(instance_id = id)
        db_instance_status(id = id, status = method)
        return('Instance rebooting')
      },
      error  = function(err) {
        stop(err)
      })
    },

    'terminate' = {
      tryCatch({
        ec2_instance_terminate(ids = id, force = TRUE)
        db_instance_status(id = id, status = method)
        return('Terminate success')
      },
      error = function(err) {
        stop('Terminate fail')
      })
    },

    'modify' = {
      if (is.null(instance_type)) {
        stop('Must supply an instance type, see https://aws.amazon.com/ec2/instance-types/ for applicable types')
      }
      tryCatch({
        ec2_instance_modify(instance_id = id, value = instance_type)
        db_instance_status(id = id, status = method)
      },
      error = function(err) {
        stop(err)
      })
    }
  )
}


