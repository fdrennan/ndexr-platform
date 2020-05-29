library(redditor)

# library(dbx)
# virtualenv_install(envname = 'redditor', packages = 'spacy')
spacy <- import("spacy")
# py_config()
# sudo /Users/fdrennan/.virtualenvs/redditor/bin/python -m spacy download en_core_web_sm
nlp <- spacy$load("en_core_web_sm")

reddit_con <- reddit_connector()
con <- postgres_connector()



response <- find_posts(search_term = "Astronaut", limit = 10) %>%
  mutate(
    permalink = paste0("http://reddit.com", permalink)
  )

reddit_data <- map(response$permalink, ~ get_url(reddit = reddit_con, url = ., n_seconds = 3))


# update_comments_to_word()

# View(full_data)



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
