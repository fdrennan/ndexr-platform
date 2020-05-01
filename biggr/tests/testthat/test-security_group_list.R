library(biggr)
library(stringr)

test_that("security_group_list return the correct class", {
  expect_equal(
    {
      is.data.frame(security_group_list())
    },
    TRUE
  )
})
