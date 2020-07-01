library(redditor)
library(biggr)

refresh <- function() {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))
  dbExecute(
    conn = con,
    statement = read_file("../../sql/materialized_vrefresh_urls_count_by_day.sql")
  )
}

refresh()
