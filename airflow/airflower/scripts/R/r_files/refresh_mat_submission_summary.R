library(redditor)
library(biggr)

refresh <- function() {
  con <- postgres_connector(POSTGRES_PORT = 5433)
  on.exit(dbDisconnect(con))
  dbExecute(
    conn = con,
    statement = read_file("../../sql/materialized_views/refresh_mat_submission_summary.sql")
  )
}

refresh()
