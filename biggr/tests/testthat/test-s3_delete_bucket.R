library(biggr)

bucket_name <- biggr::rand_name()
s3_create_bucket(bucket_name = bucket_name)
test_that("s3 bucket creation/deletion works", {
  expect_equal(
    s3_delete_bucket(bucket_name),
    TRUE
  )
})



