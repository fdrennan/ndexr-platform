#' @export postgres_connector
postgres_connector <- function() {
  n <- 1
  message("First attempt at connection")
  repeat {
    connection <- try({
      dbConnect(RPostgres::Postgres(),
        host = Sys.getenv("POSTGRES_HOST"),
        port = Sys.getenv("POSTGRES_PORT"),
        user = Sys.getenv("POSTGRES_USER"),
        password = Sys.getenv("POSTGRES_PASSWORD"),
        dbname = Sys.getenv("POSTGRES_DB")
      )
    })

    if (!inherits(connection, "try-error")) {
      break
    } else {
      if (n > 5) {
        stop("Database connection failed")
      }
      n <- n + 1
      message(glue("Trying to connect: try {n}"))
    }
  }

  connection
}

#' @export my_collect
my_collect <- function(connection) {
  connection %>%
    mutate_if(is.numeric, as.numeric) %>%
    collect()
}

#' @export str_detect_any
str_detect_any <- function(string = NULL, pattern = NULL) {
  any(str_detect(string = str_to_lower(string), pattern = pattern))
}

#' @export i_like
i_like <- function(string_value, query) {
  str_detect(str_to_lower(string_value), query)
}

#' @export send_messge
send_message <- function(messages = NULL, SLACK_API_KEY = NULL, read_env = TRUE) {
  if (read_env) {
    SLACK_API_KEY <- Sys.getenv("SLACK_API_KEY")
  }
  base_url <- glue("https://hooks.slack.com/services/{SLACK_API_KEY}")
  message(paste0("\n", messages, "\n"))
  text <- paste0("{\"text\": \"", messages, "\"}")
  messages <- paste0(
    "curl -X POST -H 'Content-type: application/json' --data ",
    "'", str_squish(text), "' ", base_url
  )
  system(messages)
}

#' @export count_submissions
count_submissions <- function(time_bound = TRUE) {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))
  submissions <- tbl(con, in_schema("public", "submissions"))
  prior <-
    submissions %>%
    count(name = "n_obs") %>%
    my_collect()

  send_message(glue("Number of submissions: {prior$n_obs}"), SLACK_API_KEY = Sys.getenv("SLACK_API_KEY"))
  prior
}

#' @export reddit_connector
reddit_connector <- function() {
  praw <- import("praw")
  reddit_con <- praw$Reddit(
    client_id = Sys.getenv("REDDIT_CLIENT"),
    client_secret = Sys.getenv("REDDIT_AUTH"),
    user_agent = Sys.getenv("USER_AGENT"),
    username = Sys.getenv("USERNAME"),
    password = Sys.getenv("PASSWORD")
  )
  reddit_con
}

#' @export update_comments_to_word
update_comments_to_word <- function() {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))

  comments_to_parse <- "
    select *
    from public.comments
    where comment_key not in (select comment_key from public.comments_to_word) and
          body != ''
  "
  comments <- dbGetQuery(conn = con, comments_to_parse) %>%
    mutate(doc_id = paste0("text", row_number()))

  message(glue("Comments to be parsed: {nrow(comments)}"))

  if (nrow(comments) == 0) {
    message("Exiting, no comments to parse")
    return(TRUE)
  }

  parsedtxt <- spacy_parse(comments$body)

  full_data <- inner_join(parsedtxt, comments, by = "doc_id")

  full_data_selection <-
    full_data %>%
    mutate(token_key = glue("{comment_key}-{sentence_id}-{token_id}")) %>%
    select(token_key, comment_key, submission, author, subreddit, sentence_id, token_id, token, lemma, pos, entity)

  tryCatch(
    {
      dbxUpsert(con, "comments_to_word", full_data_selection, where_cols = c("token_key"))
    },
    error = function(e) {
      message(str_sub(as.character(e), 1, 100))
      message("Something went wrong in comments_to_word upsert")
    }
  )
  return(TRUE)
}

#' @export backup_submissions_to_s3
backup_submissions_to_s3 <- function(keep_days = 2) {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))
  message("Looking for days to store")
  submissions <-
    tbl(con, in_schema("public", "submissions")) %>%
    mutate(
      date_created = sql("date_trunc('days', created_utc::timestamptz)")
    ) %>%
    filter(date_created <= local(now(tzone = "UTC") - days(keep_days)))

  message("...")
  submission_times <-
    submissions %>%
    distinct(date_created) %>%
    collect()

  message("...")
  dates_gathered <- as.character(with_tz(submission_times$date_created, tzone = "UTC"))
  file_names <- paste0(dates_gathered, ".csv")

  message("...")

  existing_files <- tryCatch(
    {
      s3_list_objects(bucket_name = Sys.getenv("REDDITOR_S3_TABLE"))$key
    },
    error = function(err) {
      message("Nothing in s3")
      return("Nothing there")
    }
  )

  files_to_create <- dates_gathered[!dates_gathered %in% str_remove(existing_files, "\\.tar\\.gz")]
  message("...")
  walk(
    files_to_create,
    function(query_time) {
      message("----------------------------------------------------")
      message(glue("Building {query_time}"))
      send_message(glue("Saving to S3: {query_time}"))
      submission_hour <-
        submissions %>%
        filter(
          date_created == query_time
        ) %>%
        my_collect()
      message(glue("Rows: {nrow(submission_hour)}"))
      file_location <- tempdir()
      file_name <- paste0(query_time, ".csv")
      zip_name <- paste0(query_time, ".tar.gz")
      temp_file_location <- file.path(file_location, file_name)
      write_csv(submission_hour, temp_file_location)
      temp_zip_location <- file.path(file_location, zip_name)
      tar(temp_zip_location, temp_file_location, compression = "gzip", tar = "tar")
      message(glue("Uploading... {file_name}"))
      response <- s3_upload_file(bucket = Sys.getenv("REDDITOR_S3_TABLE"), from = temp_zip_location, to = zip_name, make_public = TRUE)
      if (str_detect(response, "https")) {
        message(glue("Deleting {temp_file_location}"))
        file_delete(temp_file_location)
        message(glue("Deleting {temp_zip_location}"))
        file_delete(temp_zip_location)
        delete_statement <- glue("delete from submissions where date_trunc('days', created_utc::timestamptz) = '{query_time}'")
        message(delete_statement)
        dbExecute(conn = con, statement = delete_statement)
      }
    }
  )
}
