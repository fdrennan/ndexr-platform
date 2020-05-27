library(redditor)
# library(biggr)
# library(dbx)

reddit_con <- reddit_connector()
con <- postgres_connector()

response <- find_posts(search_term = "Nancy Pelosi", limit = 10) %>%
  mutate(
    permalink = paste0("http://reddit.com", permalink)
  )

reddit_data <- map(response$permalink, ~ get_url(reddit = reddit_con, url = .))

map(reddit_data, function(x) {
  x
})
