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
