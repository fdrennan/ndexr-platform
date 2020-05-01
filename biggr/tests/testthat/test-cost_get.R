# library(biggr)
# I turned off this unit test, because there is a one cent charge for every request.
#
# test_that("cost_get returns a dataframe", {
#   expect_warning(cost_get())
#   expect_error(cost_get(from = Sys.Date(), to = Sys.Date() + lubridate::days(100)))
#   expect_equal(
#     colnames(cost_get(from = Sys.Date(), to = lubridate::ceiling_date(Sys.Date(), "month"))),
#     c("start", "unblended_cost", "blended_cost", "usage_quantity")
#   )
# })
