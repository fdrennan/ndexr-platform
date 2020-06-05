#' @export plot_submissions
plot_submissions <- function(time_grouping = "hour",
                             timezone = "MDT",
                             to_date = Sys.Date() + 1,
                             from_date = Sys.Date() - 2) {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))
  submissions <- tbl(con, in_schema("public", "submissions"))
  submission_count <- submissions %>%
    mutate(
      created_utc = sql("cast(created_utc as timestamptz)"),
      created_utc = sql(glue("created_utc at time zone \'utc\' at time zone \'{timezone}\'")),
      created_utc = date_trunc(time_grouping, created_utc)
    ) %>%
    filter(between(created_utc, from_date, to_date)) %>%
    group_by(created_utc) %>%
    count(name = "n_observations") %>%
    ungroup() %>%
    my_collect()

  gg <-
    ggplot(submission_count) +
    aes(x = created_utc, y = n_observations) +
    geom_col() +
    # scale_colour_gradient() +
    xlab(glue("Created at - {timezone}")) +
    ylab("Number of Submissions") +
    ggtitle(glue("Number of Submissions by the {str_to_sentence(time_grouping)}"))

  gg
}

#' @export plot_submission_query
plot_submission_query <- function(submission_query,
                                  from = Sys.Date() - 1,
                                  to = Sys.Date() + 1) {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn=con))
  tbl(con, in_schema('public', 'submissions')) %>%
    filter(between(created_utc, from, to)) %>%
    filter(str_detect(str_to_lower(selftext), submission_query)) %>%
    group_by(created_utc) %>%
    count(name = 'n_obs') %>%
    mutate(created_utc = sql('created_utc::timestamptz')) %>%
    my_collect %>%
    ungroup %>%
    mutate(
      created_utc = floor_date(created_utc, 'hour')
    ) %>%
    group_by(created_utc) %>%
    count(name = 'n_observations') %>%
    ggplot() +
    aes(x = created_utc, y = n_observations) +
    geom_line()
}
