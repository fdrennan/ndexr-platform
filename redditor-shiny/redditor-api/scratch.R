library(redditor)
library(biggr)
library(dbx)

praw <- reticulate::import("praw")

reddit_con <- praw$Reddit(
  client_id = Sys.getenv("REDDIT_CLIENT"),
  client_secret = Sys.getenv("REDDIT_AUTH"),
  user_agent = Sys.getenv("USER_AGENT"),
  username = Sys.getenv("USERNAME"),
  password = Sys.getenv("PASSWORD")
)



while (TRUE) {
  con <- postgres_connector()
  tryCatch(
    {
      gather_submissions(con = con, reddit_con = reddit_con)
    },
    error = function(e) {
      send_message(glue("{e}"))
      Sys.sleep(10)
    }
  )
  dbDisconnect(conn = con)
}
