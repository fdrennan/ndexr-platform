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




create_thread <- function(submission = NULL) {

  submission_parser <-
    submission %>%
    select(link_id, parent_id, id, body) %>%
    mutate(
      parents = str_sub(parent_id, 4, -1)
    )

  end_subs <- map_lgl(submission_parser$id, function(x) {
    !any(str_detect(submission_parser$parent_id, x))
  })

  end_ids <- submission_parser[end_subs,]$id
  permalink_id = unique(submission_parser$link_id)
  map(
    end_ids,
    function(x) {
      vector_list = x
      continue_running = TRUE
      while(continue_running) {
        parent <- filter(submission_parser, str_detect(id, x))$parents
        if(str_detect(permalink_id, parent)) {
          continue_running = FALSE
        } else {
          x <- unique(filter(submission_parser, str_detect(parents, parent))$parents)
          vector_list <-
            append(vector_list, x)
        }
      }
      return(vector_list)
    }
  )
}

threads <- create_thread(submission)

submission %>%
  filter(
    id %in% threads[[76]]
  ) %>% View()

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
