library(redditor)

reddit_con <- reddit_connector()

response <- get_submission(reddit = reddit_con, name = 'all', type = 'new', limit = 10)

# connection <- postgres_connector()
# submissions <- tbl(connection, in_schema('public', 'submissions'))
# response <-
#   submissions %>%
#   group_by(url, author, subreddit) %>%
#   count(sort = TRUE) %>%
#   my_collect()
#
# response %>%
#   filter(str_detect(url, 'cbc.ca'))

# configure_aws(aws_access_key_id = Sys.getenv("AWS_ACCESS"), aws_secret_access_key = Sys.getenv("AWS_SECRET"), default.region = Sys.getenv("AWS_REGION"))
# response <-

# comment_gather_on <- function(key = 'protest') {
#   con <- postgres_connector()
#   on.exit(dbDisconnect(conn = con))
#   gf <-
#     submissions <- tbl(con, in_schema('public', 'submissions')) %>%
#     filter(sql('created_utc::timestamptz') <= local(Sys.Date() - 3)) %>%
#     filter(str_detect(str_to_lower(selftext), key)) %>%
#     my_collect()
#
#   walk(gf$permalink, build_submission_stack)
# }
#
# comment_gather_on(



# walk2(files, resp$key, ~ download.file(url = .x, destfile = .y))

con <- postgres_connector()
submissions <- tbl(con, in_schema("public", "submissions"))

if (!file.exists("response.csv")) {
  response <-
    submissions %>%
    my_collect()

  write_csv(response, "response.csv")
} else {
  response <- read_csv("response.csv")
}



if (!file.exists("summary_data.csv")) {
  summary_data <-
    response %>%
    group_by(author) %>%
    summarise(
      n_subreddits = n_distinct(subreddit),
      n_post = n(),
      n_urls = n_distinct(url)
    ) %>%
    my_collect()
  write_csv(summary_data, "summary_data.csv")
} else {
  summary_data <- read_csv("summary_data.csv")
}


summary_data %>%
  head()

authors <-
  summary_data %>%
  mutate(
    spread = n_urls / n_subreddits,
    diff = n_subreddits - n_post
  ) %>%
  filter(
    # diff < -100,
    n_urls > 150,
    # n_subreddits > 30
  ) %>%
  # arrange(desc(diff)) %>%
  pull(author) %>%
  sample(., 10)


response_summary <-
  response %>%
  filter(author %in% authors) %>%
  mutate(created_utc = floor_date(ymd_hms(created_utc), "5 minutes")) %>%
  group_by(author, created_utc) %>%
  # filter(str_detect(author, 'wunder')) %>%
  summarise(n_obs = n())

ggplot(response_summary) +
  aes(x = ymd_hms(created_utc), y = log(n_obs)) +
  geom_col() +
  facet_grid(author ~ .)


# tsibbles <-
response_summary %>%
  ungroup() %>%
  split(.$author) %>%
  map(function(x) {
    ggAcf(as_tsibble(select(x, created_utc, n_obs)), lag = 5)
  })

#
# response %>%
#   filter(str_detect(str_to_lower(author), 'gallowboob'))
