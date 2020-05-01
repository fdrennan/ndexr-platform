library(biggr)

bucket <- 'fdrennanunittest'
random_file <-  rand_name()
file_dir <- tempdir()
file_location <-  file.path(file_dir, random_file)
write.csv(mtcars, file_location)
file_location_aws <-
  paste0(
    "https://s3.us-east-2.amazonaws.com/fdrennanunittest/",
    random_file
  )

test_that("s3 upload and delete return the correct values", {

  expect_equal(
    s3_upload_file(
      bucket = bucket,
      from = file_location,
      to = random_file
    ),
    file_location_aws
  )

})

s3_delete_file(bucket = bucket,
               file   = random_file)
