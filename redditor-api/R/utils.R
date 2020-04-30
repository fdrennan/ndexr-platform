#' @export postgres_connector
postgres_connector = function() {
  n <- 1
  message('First attempt at connection')
  repeat {
    connection <-
      try({
        dbConnect(
          RPostgres::Postgres(),
          host = Sys.getenv('POSTGRES_HOST'),
          port = Sys.getenv('POSTGRES_PORT'),
          user = Sys.getenv('POSTGRES_USER'),
          password = Sys.getenv('POSTGRES_PASSWORD'),
          dbname = Sys.getenv('POSTGRES_DB')
        )
      })

    if (!inherits(connection, 'try-error')) {
      break
    } else {
      if (n > 100) {
        stop('Database connection failed')
      }
      n <- n + 1
      message(glue('Trying to connect: try {n}'))
    }
  }

  connection

}

#' @export my_collect
my_collect <- function(connection) {
  connection %>%
    mutate_if(is.numeric, as.numeric) %>%
    collect
}

#' @export str_detect_any
str_detect_any <- function(string = NULL, pattern = NULL) {
  any(str_detect(string = str_to_lower(string), pattern = pattern))
}

#' @export i_like
i_like <- function(string_value, query) {
  str_detect(str_to_lower(string_value), query)
}
