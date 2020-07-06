library(redditor)


query <- "
select host_name, url, n_hour, n_authors, n_title, n_submissions
from urls_summary
where over_18 = 0 and
      first_observation >= now() - interval '3 day'
order by n_submissions desc
limit 100
"

con <- postgres_connector(POSTGRES_HOST = Sys.getenv('POWEREDGE'))

top_hundred_links <- dbGetQuery(conn = con, statement = query)
