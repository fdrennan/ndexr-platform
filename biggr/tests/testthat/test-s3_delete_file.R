library(biggr)

response <- s3_list_objects('fdrennanunittest')
if(is.data.frame(response)) {
  has_mtcars <- "mtcars" %in% response$key
  if(!has_mtcars) {
    write.csv(mtcars, 'mtcars')
    s3_upload_file('fdrennanunittest', 'mtcars', 'mtcars')
  }
}

test_that("s3_delete_file deletes files", {

  expect_equal(
    s3_delete_file(bucket = 'fdrennanunittest',
                   file   = 'mtcars'),
    TRUE
  )
})
