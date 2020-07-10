library(redditor)

reddit_con <- reddit_connector()
con <- postgres_connector()
top_submissions <- get_submission(reddit = reddit_con, name = "all", limit = 10L, type = "top")

dbxUpsert(con, "submissions_top", top_submissions, where_cols = c("submission_key"))



