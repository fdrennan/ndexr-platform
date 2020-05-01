library(biggr)

bucket <- 'fdrennanunittest'
random_file = rand_name()
file_dir <- tempdir()
file_location = file.path(file_dir, random_file)
write.csv(mtcars, file_location)
s3_upload_file(
  bucket = bucket,
  from = file_location,
  to = random_file
)
test_that("s3_download_files downloads files", {

  expect_equal(
    s3_download_file(bucket = bucket,
                     from   = random_file,
                     to     = file_location),
    TRUE
  )

})
