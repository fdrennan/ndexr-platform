library(biggr)

bucket_name <- rand_name()

test_that("s3 bucket creation/deletion works", {
    expect_equal(
      s3_create_bucket(bucket_name),
      paste0("http://", bucket_name, ".s3.amazonaws.com/")
    )
})

s3_delete_bucket(bucket_name = bucket_name)
