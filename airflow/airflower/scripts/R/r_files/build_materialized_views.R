library(redditor)
library(biggr)

refresh <- function() {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))
  read_file("../../sql/tables/tables.sql") %>%
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

refresh()
