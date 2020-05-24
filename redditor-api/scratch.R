library(redditor)
library(biggr)
library(dbx)

praw <- reticulate::import("praw")
reddit_con <- reddit_connector()

gather_submissions <- function(con = con, reddit_con = NULL, sleep_time = 10) {
  while (TRUE) {
    send_message("----------Gathering submissions---------")
    get_all <- get_submission(reddit = reddit_con, name = "all", limit = 3000L, type = "new")
    prior <- count_submissions()
    send_message("Uploading submissions...")
    tryCatch(
      {
        dbxUpsert(con, "submissions_test", get_all, where_cols = c("submission_key"))
      },
      error = function(e) {
        browser()
      }
    )
    after <- count_submissions()
    send_message("Checking submission counts...")
    new_submissions <- after$n_obs - prior$n_obs
    downloaded_rows <- nrow(get_all)
    overlap_ratio <- round(1 - new_submissions / downloaded_rows, 2)
    if (overlap_ratio < .4) {
      sleep_time <- sleep_time - 2
      sleep_time <- max(2, sleep_time)
      send_message(glue("Updating sleep_time to {sleep_time}"))
    } else if (overlap_ratio > .6) {
      sleep_time <- sleep_time + 2
      sleep_time <- min(20, sleep_time)
      send_message(glue("Updating sleep_time to {sleep_time}"))
    }
    send_message(glue("Sleep Time: {sleep_time} -- Downloaded rows: {downloaded_rows} -- New submissions in table: {new_submissions} -- Overlap Ratio: {overlap_ratio}"))
    Sys.sleep(sleep_time)
  }
}

while (TRUE) {
  con <- postgres_connector()
  tryCatch(
    {
      gather_submissions(con = con, reddit_con = reddit_con)
    },
    error = function(e) {
      send_message(glue("{str_sub(as.character(e), 1, 100)}"))
      Sys.sleep(10)
    }
  )
  dbDisconnect(conn = con)
}
