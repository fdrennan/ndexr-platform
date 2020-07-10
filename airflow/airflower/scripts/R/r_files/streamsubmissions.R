library(biggr)
library(redditor)
library(dbx)

praw <- reticulate::import("praw")
reddit_con <- reddit_connector()

while (TRUE) {
  con <- postgres_connector()
  tryCatch(
    {
      gather_submissions(con = con, reddit_con = reddit_con, forced_sleep_time = 25)
    },
    error = function(e) {
      Sys.sleep(60*5)
      send_message(glue("{str_sub(as.character(e), 1, 100)}"))
    }
  )
  dbDisconnect(conn = con)
}
