#' security_group_list
#' @importFrom purrr map_df
#' @importFrom tibble tibble
#' @export security_group_list
security_group_list <- function() {
  resource <- resource_ec2()
  client <- client_ec2()

  response <- client$describe_security_groups()
  response <- response$SecurityGroups

  security_group_list <-
    map_df(response, function(x) {
      tibble(group_name = x$GroupName,
             group_id = x$GroupId)
    })

  security_group_list
}

#' security_group_list
#' @importFrom purrr map_df
#' @importFrom tibble tibble
#' @export security_group_data
security_group_data <- function() {
  resource <- resource_ec2()
  client <- client_ec2()


  response <- client$describe_security_groups()
  response <- response$SecurityGroups
  response <-
    response %>%
    map(
      function(sg) {
        dfs <-
          sg$IpPermissions %>%
          map(
            function(sg_id) {
              if(is.null(unlist(sg_id$IpRanges))) {
                return('')
              } else {

                sg_tibble <- tibble(ip_ranges =  unlist(sg_id$IpRanges))

                if(is.null(sg_id$FromPort) & is.null(sg_id$ToPort)) {
                  sg_tibble$from_port = 'Anywhere'
                  sg_tibble$to_port = 'Anywhere'
                } else {
                  sg_tibble$from_port = sg_id$FromPort
                  sg_tibble$to_port = sg_id$ToPort
                }

                sg_tibble %>%
                  mutate_all(as.character)

              }
            }
          ) %>%
          keep(is.data.frame)

        if(length(dfs) > 0) {
          dfs <- bind_rows(dfs)
          dfs$group_name =  sg$GroupName
          dfs$group_id =  sg$GroupId
        }

        dfs
      }
    )

  response <-
    response %>%
    keep(
      ~ length(.) > 0
    ) %>%
    bind_rows

  response
}

