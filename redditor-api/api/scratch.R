library(redditor)

reddit_con <- reddit_connector()
con <- postgres_connector()

gather_submissions <- function(con = con, reddit_con = NULL, forced_sleep_time = 60) {
  while (TRUE) {
    get_all <- get_submission(reddit = reddit_con, name = "all", limit = 1000L, type = "new")
    tryCatch(
      {
        dbxUpsert(con, "submissions", get_all, where_cols = c("submission_key"))
      },
      error = function(e) {
        message("Something went wrong with upsert in gather_submissions, {as.character(Sys.time())}")
      }
    )
    tryCatch(expr = {
      throttle_me(reddit_con)
      Sys.sleep(forced_sleep_time)
    }, error = function(err) {
      send_message("Something went wrong in get_submission's throttle")
      send_message(as.character(err))
    })
  }
}

gather_submissions(con = con, reddit_con = reddit_con, 60)
