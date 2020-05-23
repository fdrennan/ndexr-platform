library(biggr)

configure_aws(
  aws_access_key_id = Sys.getenv("AWS_ACCESS"),
  aws_secret_access_key = Sys.getenv("AWS_SECRET"),
  default.region = Sys.getenv("AWS_REGION")
)

# security_group_delete(security_group_id = sg_id$group_id)
# keyfile_delete(keyname = Sys.getenv("PEM_NAME"))

sg_id <-
  filter(
    security_group_list(),
    group_name == Sys.getenv("SECURITY_GROUP_NAME")
  )


if (nrow(sg_id) == 0) {
  sg_name <-
    security_group_create(group_name = Sys.getenv("SECURITY_GROUP_NAME"))

  security_group_envoke(
    sg_name = Sys.getenv("SECURITY_GROUP_NAME"),
    ports = c(5439, 5432, 80, 8000:8010, 8080, 22, 27017, 3000)
  )
}
