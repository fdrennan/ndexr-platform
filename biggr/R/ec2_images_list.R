#' ec2_images_list
#' @param owners self
#' @export ec2_images_list
ec2_images_list <- function(owners = 'self') {

  client <- biggr::client_ec2()
  my_images <- client$describe_images(
    Owners=list(owners)
  )

  my_images$Images %>%
    map_df(
      function(x) {
        tibble(
          name = x$Name,
          id   = x$ImageId
        )
      }
    )

}

