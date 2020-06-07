library(redditor)

reddit_con <- reddit_connector()

# response <-
  # build_submission_stack(permalink = "/r/SeriousConversation/comments/gteetu/you_know_what_would_significantly_impact_police/")

comment_gather_on <- function(key = 'george floyd') {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))
  gf <-
    submissions <- tbl(con, in_schema('public', 'submissions')) %>%
    filter(sql('created_utc::timestamptz') <= local(Sys.Date() - 3)) %>%
    filter(str_detect(str_to_lower(selftext), key)) %>%
    my_collect()

  walk(gf$permalink, build_submission_stack)
}

comment_gather_on()

# summarise_thread_stack(response) %>%
  # arrange(desc(engagement_ratio))


# plot_submission_query(submission_query = 'protests') +
  # ggtitle('Reddit posts mentioning protests')

# con = postgres_connector()
# resp <-
  # dbGet

#

#


# fn <- 
  # read_html('https://en.wikipedia.org/wiki/List_of_fake_news_websites') %>% 
  # html_table(fill = T) %>% 
  

# %>%

