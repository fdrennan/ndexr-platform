#' cost_get
#' A function to get cost on a specified date range. It defaults to a monthly
#' range if from io are not specified
#' @importFrom lubridate floor_date
#' @importFrom lubridate ceiling_date
#' @importFrom purrr %>%
#' @param from The earliest date to grab data. No longer than a year ago.
#' @param to The latest date to grab data. No later than the end of the month.
#' @return Current AWS costs
#' @examples
#' cost_get(from = '2019-01-01', to = '2019-03-05')
#' @export cost_get
cost_get <- function(from = NA, to = NA) {

  if(any(is.na(from), is.na(to))) {
    from = as.character(floor_date(Sys.Date(), unit = 'month'))
    to = as.character(ceiling_date(Sys.Date(), unit = 'month'))
    warning('NA supplied in from or to. Defaulting to monthly range')

  } else {
    from = as.character(from)
    to = as.character(to)
  }

  costs = client_cost()

  results <- costs$get_cost_and_usage(
    TimePeriod=list(
      Start = from,
      End = to
    ),
    Granularity = 'DAILY',
    Metrics = list('UnblendedCost', 'UsageQuantity', 'BlendedCost')
  )

  results$ResultsByTime %>%
    map_df(
      function(x) {
        tibble(start = x$TimePeriod$Start,
               unblended_cost = as.numeric(x$Total$UnblendedCost$Amount),
               blended_cost = as.numeric(x$Total$BlendedCost$Amount),
               usage_quantity = as.numeric(x$Total$UsageQuantity$Amount))
      }
    )

}
