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

get_submission <- function(reddit = NULL, name = NULL, type = NULL, limit = 10) {
  subreddit <- subreddit <- reddit$subreddit(name)
  subreddit <- switch(type, controversial = {
    subreddit$controversial(limit = limit)
  }, hot = {
    subreddit$hot(limit = limit)
  }, new = {
    subreddit$new(limit = limit)
  }, top = {
    subreddit$top(limit = limit)
  }, )
  comments <- iterate(subreddit)
  meta_data <- map_df(comments, ~ parse_meta(.))
  meta_data
}

get_all <- get_submission(reddit = reddit_con, name = "all", limit = 3000L, type = "hot")

get_url(reddit = reddit_con, paste0("http://reddit.com", get_all$permalink[[1]]))
