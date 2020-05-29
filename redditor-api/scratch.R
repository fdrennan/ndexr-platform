library(redditor)

# library(dbx)
# virtualenv_install(envname = 'redditor', packages = 'spacy')
spacy <- import("spacy")
# py_config()
# sudo /Users/fdrennan/.virtualenvs/redditor/bin/python -m spacy download en_core_web_sm
nlp <- spacy$load("en_core_web_sm")

reddit_con <- reddit_connector()
con <- postgres_connector()

response <-
  tbl(con, in_schema('public', 'submissions')) %>%
  filter(subreddit == 'politics') %>%
  mutate(created_utc = sql('created_utc::timestamptz')) %>%
  my_collect

# plot_subreddit <- function(df) {
#   df %>%
#     mutate(created_utc = floor_date(created_utc, 'hour')) %>%
#     group_by(created_utc) %>%
#     count %>%
#     ggplot() +
#     aes(x = created_utc, y = n) +
#     geom_line()
# }
#
# plot_subreddit(response)

reddit_data <- map(response$permalink, ~ get_url(reddit = reddit_con, permalink = ., n_seconds = 10))


# # update_comments_to_word()
#
#
# tbl(con, in_schema('public', 'comments_to_word')) %>%
#   filter(subreddit == 'politics') %>%
#   mutate(
#     word = lemma
#   ) %>%
#   filter(pos == 'PROPN') %>%
#   collect %>%
#   anti_join(stop_words) %>%
#   select(-word) %>%
#   group_by(lemma) %>%
#   summarise(n = n()) %>%
#   arrange(desc(n)) %>%
#   as.data.frame()
#
# # View(full_data)



# response <- find_posts(search_term = "Nancy Pelosi", limit = 100) %>%
#   mutate(
#     permalink = paste0("http://reddit.com", permalink)
#   )
#
# reddit_data <- map(response$permalink, ~ get_url(reddit = reddit_con, url = ., n_seconds = 3))
#
# map(reddit_data, function(x) {
#   x$comments
# })
#
# # process documents and obtain a data.table

# parsedtxt

# response_summary <- response %>%
#   mutate(
#     created_utc = floor_date(ymd_hms(created_utc), 'hour')
#   ) %>%
#   group_by(created_utc) %>%
#   count(name = 'n_observations')
#
# ggplot(response_summary) +
#   aes( x = created_utc, y = n_observations) +
#   geom_line()

#
