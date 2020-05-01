library(biggr)

bucket_name <- rand_name()

test_that("s3 list objectss", {
  expect_equal(
    is.data.frame(s3_list_objects('fdrennanunittest')),
    TRUE
  )
})

# s3_delete_bucket(bucket_name = bucket_name)
