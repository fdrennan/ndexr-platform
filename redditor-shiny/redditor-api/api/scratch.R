library(redditor)

rcon <- reddit_connector()
pcon <- postgres_connector()

submissions <- find_posts(search_term = "Defeat Trump in November", limit = 10) %>%
  mutate(permalink = paste0("http://reddit.com", permalink)) %>%
  collect()

response <- map(
  submissions$permalink,
  ~ get_url(reddit = rcon, url = .)
)

resp <- map_df(response, ~ .$meta_data)
