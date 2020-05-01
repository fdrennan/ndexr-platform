library(biggr)

test_that("client_s3 return the correct class", {
  expect_equal(class(client_s3())[[1]], "botocore.client.S3")
})
