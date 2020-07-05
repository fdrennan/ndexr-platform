library(redditor)

refresh <- function() {
  con <- postgres_connector(POSTGRES_PORT = 5432, POSTGRES_HOST = Sys.getenv('POWEREDGE'))
  on.exit(dbDisconnect(con))
  dbExecute(
    conn = con,
    statement = read_file("../../sql/materialized_views/refresh_mat_meta_statistics.sql")
  )
}

refresh()
