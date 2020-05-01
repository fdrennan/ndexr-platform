#' security_group_create
#' @importFrom purrr keep
#' @importFrom dplyr filter
#' @importFrom dplyr pull
#' @param  group_name Name of security group
#' @param  description
#' @export security_group_create
security_group_create <- function(group_name = NA, description = 'Add a description') {

  resource <- resource_ec2()
  client <- client_ec2()

  security_group_df <- security_group_list()

  if(!any(security_group_df$group_name == group_name)) {
    create_security <-
      resource$create_security_group(
        GroupName=group_name,
        Description='for automated server'
      )
  } else {
    security_group_id = security_group_df %>%
      filter(group_name == group_name) %>%
      pull(group_id)
    }

    security_group_id <-
      create_security$id

  security_group_id
}


#' security_group_create
#' @importFrom purrr keep
#' @importFrom dplyr filter
#' @importFrom dplyr pull
#' @param  group_name Name of security group
#' @param  ports Name of security group
#' @export security_group_revoke
security_group_revoke <- function(sg_name = NA, ports = NULL, ips = NULL) {

  resource <- resource_ec2()
  client <- client_ec2()

  security_group_df <- security_group_list()
  security_group_id <- security_group_df %>%
    filter(group_name == sg_name) %>%
    pull(group_id)


    if(is.null(ips)) {

      walk(
        ports,
        ~ client$revoke_security_group_ingress(
          GroupName=sg_name,
          IpProtocol = "tcp",
          CidrIp     = "0.0.0.0/0",
          FromPort = as.integer(.),
          ToPort = as.integer(.)
        )
      )
    } else {

      grid <- expand.grid(ports, ips) %>% mutate(id = row_number())
      colnames(grid) = c('port', 'ip', 'id')
      grid %>%
        split(.$id) %>%
        walk(
          function(x) {
            client$revoke_security_group_ingress(
              GroupName=sg_name,
              IpProtocol = "tcp",
              CidrIp     = paste0(x$ip, "/32"),
              FromPort = as.integer(x$port),
              ToPort = as.integer(x$port)

        )}
        )
    }

  security_group_id
}


#' security_group_create
#' @importFrom purrr keep
#' @importFrom dplyr filter
#' @importFrom dplyr pull
#' @param  sg_name Name of security group
#' @param  ports Name of security group
#' @export security_group_envoke
security_group_envoke <- function(sg_name = NA, ports = NULL, ips = NULL) {

  resource <- resource_ec2()
  client <- client_ec2()

  security_group_df <- security_group_list()
  security_group_id <- security_group_df %>%
    filter(group_name == sg_name) %>%
    pull(group_id)

  message('Revoking')

  security_group_revoke(sg_name, ports, ips)

  if(is.null(ips)) {
    walk(
      ports,
      ~ client$authorize_security_group_ingress(
        GroupName=sg_name,
        IpProtocol = "tcp",
        CidrIp     = "0.0.0.0/0",
        FromPort = as.integer(.),
        ToPort = as.integer(.)
      )
    )
  } else {
    grid <- expand.grid(ports, ips) %>% mutate(id = row_number())
    colnames(grid) = c('port', 'ip', 'id')
    grid %>%
      split(.$id) %>%
      walk(
        ~ client$authorize_security_group_ingress(
          GroupName=sg_name,
          IpProtocol = "tcp",
          CidrIp     = paste0(.$ip, "/32"),
          FromPort = as.integer(.$port),
          ToPort = as.integer(.$port)
        ))
  }

  security_group_id
}

