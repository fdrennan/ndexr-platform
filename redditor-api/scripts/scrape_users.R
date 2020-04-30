library(redditor)
library(glue)
library(dbplyr)

# Hook up to reddit
praw = reticulate::import('praw')
reddit = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                     client_secret=Sys.getenv('REDDIT_AUTH'),
                     user_agent=Sys.getenv('USER_AGENT'),
                     username=Sys.getenv('USERNAME'),
                     password=Sys.getenv('PASSWORD'))

con = postgres_connector()

users <-
  tbl(con, in_schema('public', 'users')) %>%
  filter(is.na(last_scraped))

authors <-
  users %>%
  collect %>%
  pull(author)

dbDisconnect(con)

walk(
  sample(authors, 1000),
  function(user) {
    con = postgres_connector()
    message(glue('User: {user}'))
    response = get_user_comments(reddit = reddit, user = user, limit = NULL)
    dbWriteTable(
      conn = con, name = 'user_comments', value = response, append = TRUE
    )
    dbDisconnect(con)
    Sys.sleep(100)
  }
)

