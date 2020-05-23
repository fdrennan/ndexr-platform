library(biggr)

con <- postgres_connector()

redditor_servers <- tbl(con, in_schema("public", "redditor_servers"))
