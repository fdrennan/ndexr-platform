library(redditor)
library(biggr)


refresh_mat <- function() {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))
  read_file("../../sql/materialized_views/materialized_views.sql") %>%
    str_split(pattern = "SPLIT") %>%
    unlist() %>%
    map(
      function(x) {
        print(x)
        dbExecute(
          conn = con, statement = x
        )
      }
    )
}

refresh <- function() {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))
  all_tables <- db_list_tables(con = con)
  if (length(all_tables) > 1) {
    return(TRUE)
  }
  read_file("../../sql/tables/tables.sql") %>%
    str_split(pattern = "SPLIT") %>%
    unlist() %>%
    map(
      function(x) {
        dbExecute(
          conn = con, statement = x
        )
      }
    )
  refresh_mat()
}

refresh()
