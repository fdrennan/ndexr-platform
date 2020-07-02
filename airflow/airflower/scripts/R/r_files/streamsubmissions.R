library(biggr)
library(redditor)
library(dbx)

praw <- reticulate::import("praw")
reddit_con <- reddit_connector()

while (TRUE) {
  con <- postgres_connector()
  tryCatch(
    {
      gather_submissions(con = con, reddit_con = reddit_con, sleep_time = 2)
    },
    error = function(e) {
      send_message(glue("{str_sub(as.character(e), 1, 100)}"))
    }
  )
  dbDisconnect(conn = con)
}