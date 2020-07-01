library(redditor)

refresh <- function() {
  con <- postgres_connector(POSTGRES_PORT = 5433)
  on.exit(dbDisconnect(con))
  dbExecute(
    conn = con,
    statement = read_file("../../sql/materialized_views/refresh_urls_count_by_day.sql")
  )
}

refresh()
