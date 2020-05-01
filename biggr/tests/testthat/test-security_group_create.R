library(biggr)
library(stringr)
security_group_name <-
  rand_name()
test_that("resource_s3 return the correct class", {
  sg_id <- security_group_create(group_name = security_group_name)
  expect_equal(
    str_detect(sg_id, "sg-"),
    TRUE
  )
  security_group_delete(sg_id)
})

