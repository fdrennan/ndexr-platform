library(redditor)

postgres_connector <- function() {
  n <- 1
  message('First attempt at connection')
  repeat {
    connection <-
      try({
        dbConnect(
          RPostgres::Postgres(),
          host = '192.168.0.52',
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


con = postgres_connector()

streamall <- tbl(con, in_schema('public', 'streamall'))


response <- 
  streamall %>% 
  filter(str_detect(str_to_lower(body), 'fuck')) %>% 
  arrange(desc(created_utc)) %>% 
  head(100000) %>% 
  collect %>% 
  mutate(
    created_utc = round_date(created_utc, '30 minutes')
  ) %>% 
  group_by(created_utc) %>% 
  count(name = 'n_observations')


ggplot(response) +
  aes(x = with_tz(created_utc, tzone = 'MST') + hours(1), y = n_observations) +
  geom_point(size = 1/10) +
  geom_col() 
