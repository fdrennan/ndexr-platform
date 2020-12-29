library(biggr)
library(redditor)
library(dbx)

praw <- reticulate::import("praw")
reddit_con <- reddit_connector()
# debug(gather_submissions)
while (TRUE) {
  con <- postgres_connector()
  tryCatch(
    {
      gather_submissions(con = con, reddit_con = reddit_con, forced_sleep_time = 25)
    },
    error = function(e) {
      Sys.sleep(60 * 5)
      send_message(glue("{str_sub(as.character(e), 1, 100)}"))
    }
  )
  dbDisconnect(conn = con)
}

# redditor::get_user_comments
#
# user <- reddit_con$redditor('lifedream11')
# all_subs <- iterate(user$submissions$top(limit = 100000))
#
#
# subreddits <- map_df(
#   all_subs,
#   function(x) {
#     tibble(
#       roze_subs = as.character(x$subreddit)
#     )
#   }
# )
#
# write_rds(subreddits, 'roze_subs.rda')
