library(redditor)

reddit_con <- reddit_connector()

get_all <- get_submission(reddit = reddit_con, name = "all", limit = 100L, type = "new")
