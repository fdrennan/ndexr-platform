library(biggr)
library(redditor)

ENV_NAME = 'XPS'
con <- redditor::postgres_connector(POSTGRES_HOST = Sys.getenv(ENV_NAME))
if(!db_has_table(con, 'costs')) {
  results <- cost_get(from = as.character(Sys.Date() - 365), to = as.character(Sys.Date() + 1))
  dbWriteTable(conn = , as.data.frame(results), 'costs')
} else {
  results <- cost_get(from = as.character(Sys.Date() - 10), to = as.character(Sys.Date() + 1))
  dbxUpsert(conn = con, table = 'costs', records = results, where_cols = c('start'))
}
