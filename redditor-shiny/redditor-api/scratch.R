library(redditor)

# upload_subreddit(
#   subreddit_name = 'politics',
#   n_seconds = 1,
#   comments_to_word = FALSE,
#   n_to_pull = 10
# )

comment_thread <- function(submission) {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))
  comments <- tbl(con, in_schema("public", "comments")) %>%
    filter(str_detect(submission, local(submission))) %>%
    collect()

  comments <-
    comments %>%
    select(id, parent_id, body, everything()) %>%
    my_collect()

  comments
}

submission <- comment_thread(submission = "gmxhj9")


submission_parser <-
  submission %>%
  select(link_id, parent_id, id)

apply(submission_parser, 2, unique)

# View(submission)


# library(dbx)
# virtualenv_install(envname = 'redditor', packages = 'spacy')
# spacy <- import("spacy")
# py_config()
# sudo /Users/fdrennan/.virtualenvs/redditor/bin/python -m spacy download en_core_web_sm



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
