library(biggr)

test_that("client_ec2 return the correct class", {
  expect_equal(class(client_ec2())[[1]], "botocore.client.EC2")
})
