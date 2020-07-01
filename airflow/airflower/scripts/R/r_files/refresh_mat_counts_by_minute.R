library(redditor)

refresh <- function() {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))
  dbExecute(
    conn = con,
    statement = read_file("../../sql/materialized_views/refresh_mat_counts_by_minute.sql")
  )
}

refresh()
