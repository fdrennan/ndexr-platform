library(redditor)


praw = reticulate::import('praw')
warnings = import('warnings')

reddit = praw$Reddit(client_id     = Sys.getenv('REDDIT_CLIENT'),
                     client_secret = Sys.getenv('REDDIT_AUTH'),
                     user_agent    = Sys.getenv('USER_AGENT'),
                     username      = Sys.getenv('USERNAME'),
                     password      = Sys.getenv('PASSWORD'))

# Hook up to postgres
con = postgres_connector()

subs_to_scrape <-
  tbl(con, in_schema('public', 'subreddits')) %>%
  filter(is.null(time_gathered)) %>%
  collect

subs <-
  subs_to_scrape  %>%
  sample_n(1000) %>%
  as.data.frame %>%
  pull(subreddit)

print(subs)

dbDisconnect(conn = con)

# debug(get_subreddit)
# a = get_subreddit(reddit, subs[[1]], limit = 1)
walk(
  subs,
  function(sub) {
    con = postgres_connector()
    message(glue('Scraping subreddit: {sub}'))
    response <- get_subreddit(reddit, sub, limit = 50)
    glimpse(response)
    dbWriteTable(
      conn = con, name = 'hot_scrapes', value = response, append = TRUE
    )
    dbDisconnect(conn = con)
    Sys.sleep(3)
  }
)

dbDisconnect(conn = con)
