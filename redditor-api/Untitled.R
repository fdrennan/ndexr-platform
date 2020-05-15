library(redditor)


con = postgres_connector()

streamall <- tbl(con, in_schema('public', 'streamall'))

most_popular_last_hour <-
  streamall %>%
    filter(created_utc >= local(now(tzone = 'utc')-hours(2))) %>%
    group_by(subreddit) %>%
    count(name='n_obs') %>%
    arrange(desc(n_obs)) %>%
    head(100) %>%
    as.data.frame

most_popular_last_hour <-
  streamall %>%
    distinct(author) %>%
    count(name='n_obs') %>%
    collect

most_popular_last_hour