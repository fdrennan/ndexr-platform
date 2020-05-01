library(biggr)

test_that("resource_ec2 return the correct class", {
  expect_equal(class(resource_ec2())[[1]], "boto3.resources.factory.ec2.ServiceResource")
})
