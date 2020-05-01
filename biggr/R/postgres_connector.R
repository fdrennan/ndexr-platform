#' redshift_connector
#' @importFrom RPostgres Postgres
#' @importFrom glue glue
#' @export postgres_connector
postgres_connector <- function() {
    n <- 1
    message('First attempt at connection')
    repeat {
      connection <-
        try({
          dbConnect(Postgres(),
                    host = Sys.getenv('POSTGRES_HOST'),
                    port = Sys.getenv('POSTGRES_PORT'),
                    user = Sys.getenv('POSTGRES_USER'),
                    password = Sys.getenv('POSTGRES_PASSWORD'),
                    dbname = Sys.getenv('POSTGRES_DB'))
        })

      if (!inherits(connection, 'try-error')) {
        break
      } else {
        if (n > 10) {
          stop('Connection to DB failed')
        }
        n <- n + 1
        message(glue('Trying to connect: try {n}'))
      }
    }

    connection

  }
