library(biggr)

test_that("client_cost return the correct class", {
  expect_equal(class(client_cost())[[1]], "botocore.client.CostExplorer")
})
