library(redditor)
library(elasticsearchr)

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
elastic_uploaded <- collect(tbl(con, in_schema('public', 'elastic_uploaded')))

counts <-
  streamall %>% 
  mutate(
    year = date_part('year', created_utc),
    month = date_part('month', created_utc),
    day = date_part('day', created_utc),
    hour = date_part('hour', created_utc),
  ) %>%
  filter(created_utc <= local(floor_date(now(tzone = 'UTC') - hours(2), 'hour'))) %>% 
  distinct(year, month, day, hour) %>% 
  arrange(year, month, day, hour) %>% 
  as.data.frame() %>% 
  mutate(id = row_number())

counts <- anti_join(counts, elastic_uploaded)

# elastic("http://localhost:9200", "streamall") %delete% TRUE
# db_drop_table(con, 'elastic_uploaded')

es <- elastic("http://localhost:9200", "streamall", "data")

max_counts = nrow(counts)

counts %>% 
  split(.$id) %>% 
  map(
    function(x) {
      print(x$id/max_counts)
      response <- 
        streamall %>% 
        mutate(
          year = date_part('year', created_utc),
          month = date_part('month', created_utc),
          day = date_part('day', created_utc),
          hour = date_part('hour', created_utc),
        ) %>% 
        filter(
          year == local(x$year),
          month == local(x$month),
          day == local(x$day),
          hour == local(x$hour)
        ) %>% 
        collect
      print(response)
      elastic("http://localhost:9200", "streamall", "data") %index% response
      dbWriteTable(conn  = con, name = 'elastic_uploaded', value = x, append = TRUE)
    }
  )

# elastic("http://localhost:9200", "streamall") %delete% TRUE

# elastic("http://localhost:9200", "iris") %delete% TRUE

# tic()

es <- elastic(Sys.getenv('ELASTIC_SEARCH'), "streamall", "data")

search_term = 'shit is funny'
by_time <- sort_on('{"created_utc": {"order": "desc"}}')

elastic_query <- query(glue(
  '{
    "bool": {
      "must": [
        { "match": { "body":   "--search_term--"        }}
      ],
      "filter": [
        { "range": { "created_utc": { "gte": "2020-05-12T00:00:00" }}}
      ]
    }
  }', .open = '--', .close='--'), size = 30)
a <- elastic("http://localhost:9200", "streamall", "data") %search% (elastic_query + by_time)
a <- elastic("http://localhost:9200", "streamall", "data") %search% (elastic_query)


sort_on()
search_term = 'trump'
esq <- query(glue(
  '{
    "match": {"body": "hello"},
    "sort": { "created_utc": "desc" }
  }', .open = '--', .close='--'), size = 30)

a <- elastic("http://localhost:9200", "streamall", "data") %search% esq
