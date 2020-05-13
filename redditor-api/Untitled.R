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

# https://cran.r-project.org/web/packages/elasticsearchr/vignettes/quick_start.html

response <-
  streamall %>% 
  filter(str_detect(str_to_lower(body), 'weijia')) %>% 
  arrange(desc(created_utc)) %>% 
  my_collect()


library(elasticsearchr)
es <- elastic("http://localhost:9200", "iris", "data")
elastic("http://localhost:9200", "iris", "data") %index% iris
# elastic("http://localhost:9200", "iris") %delete% TRUE

for_everything <- query('{
  "match_all": {}
}')

elastic("http://localhost:9200", "iris", "data") %search% for_everything

selected_fields <- select_fields('{
  "includes": ["sepal_length", "species"]
}')

elastic("http://localhost:9200", "iris", "data") %search% (for_everything + selected_fields)

