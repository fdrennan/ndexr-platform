library(redditor)
library(elasticsearchr)

 #elastic(Sys.getenv('ELASTIC_SEARCH'), "submissions") %delete% TRUE
# elastic(Sys.getenv('ELASTIC_SEARCH'), "stream_submissions_all") %delete% TRUE

dwh_table <- "submissions"
dwh_verification_table <- "submissions_to_elastic_success"
dwh_failed_verification_table <- "submissions_to_elastic_failed"
elastic_search_table <- "submissions"

con <- postgres_connector(POSTGRES_PORT = 5433)
response_table <- tbl(con, in_schema("public", dwh_table))
counts <-
  response_table %>%
  mutate(
    created_utc = sql("cast(created_utc as timestamptz)"),
    year = date_part("year", created_utc),
    month = date_part("month", created_utc),
    day = date_part("day", created_utc),
    hour = date_part("hour", created_utc),
  ) %>%
  filter(created_utc <= local(floor_date(now(tzone = "UTC") - hours(2), "hour"))) %>%
  distinct(year, month, day, hour) %>%
  arrange(year, month, day, hour) %>%
  as.data.frame() %>%
  mutate(id = row_number())

if (db_has_table(con, dwh_verification_table)) {
  elastic_uploaded <- collect(tbl(con, in_schema("public", dwh_verification_table)))
  counts <- anti_join(counts, select(elastic_uploaded, -id)) %>%
    mutate(id = row_number())
}

# elastic("http://localhost:9200", "stream_submissions_all") %delete% TRUE
max_counts <- nrow(counts)

counts <-
  counts %>%
  split(.$id)

for (hour_count in counts) {
  elastic_submission_upload_ratio <- round(hour_count$id / max_counts, 4)
  send_message(glue("Uploading Submissions to Elastic {elastic_submission_upload_ratio*100}% complete"))
  print(elastic_submission_upload_ratio)
  response <-
    response_table %>%
    mutate(
      created_utc = sql("cast(created_utc as timestamptz)"),
      year = date_part("year", created_utc),
      month = date_part("month", created_utc),
      day = date_part("day", created_utc),
      hour = date_part("hour", created_utc),
    ) %>%
    filter(
      year == local(hour_count$year),
      month == local(hour_count$month),
      day == local(hour_count$day),
      hour == local(hour_count$hour)
    ) %>%
    collect()
  print(response)
  tryCatch(
    {
      message('Uploading to Elastic')
      elastic(Sys.getenv("ELASTIC_SEARCH"), elastic_search_table, "data") %index% as.data.frame(response)
      message('Writing to table')
      dbWriteTable(conn = con, name = dwh_verification_table, value = hour_count, append = TRUE)
      message('Complete')
    },
    error = function(e) {
      message(e)
      message("Oops, something went wrong.")
      dbWriteTable(conn = con, name = dwh_failed_verification_table, value = hour_count, append = TRUE)
    }
  )
}
