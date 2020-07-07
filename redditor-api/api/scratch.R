library(redditor)

reddit_con <- reddit_connector()
con <- postgres_connector()
debug(gather_submissions)
gather_submissions(con = con, reddit_con = reddit_con)
