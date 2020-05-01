library(biggr)

test_that("Test if is null...", {
  expect_equal(if_is_null(NULL), as.character(NA))
  expect_equal(if_is_null('character'), 'character')
})
