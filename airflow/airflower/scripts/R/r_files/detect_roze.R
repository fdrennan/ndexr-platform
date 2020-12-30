library(redditor)
library(biggr)

con <- postgres_connector()

submissions <-
  tbl(con, in_schema("public", "submissions")) %>%
  filter(
    str_detect(str_to_lower(url), "youtube") |
    str_detect(str_to_lower(url), "youtu.be")
  ) %>%
  distinct(author, url, submission_key, subreddit) %>%
  collect()

detect_roze <- function(youtube_url = NULL, sleep_time = 1) {
  message(glue("Sleeping for {sleep_time} seconds."))
  Sys.sleep(sleep_time)
  # browser()
  read_html(youtube_url) %>%
    html_text() %>%
    str_detect("Roze Draw")
}

remove_keys <-
  tbl(con, in_schema("public", "detect_roze")) %>%
  distinct(submission_key) %>%
  collect()

submissions_roze <-
  tbl(con, in_schema("public", "submissions_roze")) %>%
  select(subreddit) %>%
  collect()


submissions <- 
  bind_rows(
  {
    submissions %>%
      anti_join(remove_keys, by = 'submission_key') %>% 
      inner_join(submissions_roze) 
  },
  {
    submissions %>%
      sample_n(30) 
  }
) 

sub_split <-
  submissions %>%
  anti_join(remove_keys, by = 'submission_key') %>%
  select(-subreddit) %>%
  split(seq.int(1, nrow(.)))

checking <-
  map_df(
    sub_split,
    function(x) {
      x$detected_roze <- tryCatch(expr = {
        detect_roze(x$url, 5)
      }, error = function(err) {
        message(err)
        as.character(err)
      })
      glimpse(x)
      dbxUpsert(con, "detect_roze", x, where_cols = c("submission_key"))
      x
    }
  )
 
send_message(messages = 'hello')
