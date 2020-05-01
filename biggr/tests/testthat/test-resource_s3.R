library(biggr)

test_that("resource_s3 return the correct class", {
  expect_equal(class(resource_s3())[[1]], "boto3.resources.factory.s3.ServiceResource")
})
