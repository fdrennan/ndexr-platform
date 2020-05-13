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


counts <-
  streamall %>% 
  mutate(
    year = date_part('year', created_utc),
    month = date_part('month', created_utc),
    day = date_part('day', created_utc),
    hour = date_part('hour', created_utc),
  ) %>%
  distinct(year, month, day, hour) %>% 
  arrange(year, month, day, hour) %>% 
  as.data.frame() %>% 
  mutate(id = row_number())


elastic("http://localhost:9200", "streamall") %delete% TRUE

library(elasticsearchr)
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
search_term <- 'hi'
for_everything <- query(glue('{
  "match" : {
            "body" : {
                "query" : "--search_term--"
            }
        }
}', .open = '--', .close='--'))

esq <- glue(
  '{ 
    "bool": { 
      "must": [
        { "match": { "body":   "--search_term--"        }}
      ],
      "filter": [ 
        { "range": { "created_utc": { "gte": "2015-01-01" }}}
      ]
    }
  }', .open = '--', .close='--')
) %>% query

tic()
a <- elastic("http://localhost:9200", "streamall", "data") %search% for_everything
toc()


tic()
b <- streamall %>% 
  filter(str_detect(str_to_lower(body), 'query')) %>% 
  collect
toc()

 # 
# selected_fields <- select_fields('{
#   "includes": ["sepal_length", "species"]
# }')
# 
# elastic("http://localhost:9200", "iris", "data") %search% (for_everything + selected_fields)

