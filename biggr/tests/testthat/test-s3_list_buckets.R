library(biggr)

test_that("s3 lists return the correct values", {
  response <- s3_list_buckets()
  expect_equal(
    colnames(response),
    c("name", "creation_date")
  )
})

