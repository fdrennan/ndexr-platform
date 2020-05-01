library(biggr)
library(stringr)

security_group_name <-
  rand_name()

result <- security_group_create(group_name = security_group_name)

test_that("resource_s3 return the correct class", {
  expect_equal(
    {
      security_group_delete(result)
    },
    200
  )
})
