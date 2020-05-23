library(redditor)
library(elasticsearchr)

con <- postgres_connector()

stream_submissions_all <- tbl(con, in_schema("public", "stream_submissions_all"))

counts <-
  stream_submissions_all %>%
  mutate(
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

if (db_has_table(con, "elastic_uploaded_submissions")) {
  elastic_uploaded <- collect(tbl(con, in_schema("public", "elastic_uploaded_submissions")))
  counts <- anti_join(counts, select(elastic_uploaded, -id)) %>%
    mutate(id = row_number())
}


# elastic(Sys.getenv('ELASTIC_SEARCH'), "stream_submissions_all") %delete% TRUE
# elastic("http://localhost:9200", "stream_submissions_all") %delete% TRUE
max_counts <- nrow(counts)

counts <-
  counts %>%
  split(.$id)


for (hour_count in counts) {
  print(hour_count$id / max_counts)
  response <-
    stream_submissions_all %>%
    mutate(
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
      elastic(Sys.getenv("ELASTIC_SEARCH"), "stream_submissions_all", "../../../../data") %index% as.data.frame(response)
      dbWriteTable(conn = con, name = "elastic_uploaded_submissions", value = hour_count, append = TRUE)
    },
    error = function(e) {
      print(e)
      write.csv(response, "response.csv")
      dbWriteTable(conn = con, name = "elastic_failed_submissions", value = hour_count, append = TRUE)
    }
  )
}
