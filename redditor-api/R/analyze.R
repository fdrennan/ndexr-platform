library(redditor)

analyze <- function(n_head = 1000, time_trunc = "hours") {
  con <- postgres_connector()

  on.exit(expr = {
    dbDisconnect(con)
  })

  response <-
    tbl(con, in_schema("public", "submissions"))


  response <-
    response %>%
    transmute(
      created_utc = sql("cast(created_utc as timestamp)"),
      author,
      subreddit,
      title,
      selftext,
      url
    )

  response <-
    response %>%
    mutate(created_utc = sql(local(glue("date_trunc('{time_trunc}', created_utc)")))) %>%
    arrange(desc(created_utc))

  response <- head(response, local(n_head))

  response <- collect(response)

  response
}
# debug(analyze)
response <- analyze(n_head = 100000, time_trunc = "minutes")
response %>%
  filter(author == 'lifedream11') %>%
  group_by(created_utc) %>%
  count(name = 'submissions') %>%
  ggplot() +
  aes(
    x = created_utc, y = submissions
  ) +
  geom_line()
