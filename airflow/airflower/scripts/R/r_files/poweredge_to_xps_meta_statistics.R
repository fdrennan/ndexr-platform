
library(redditor)
con <- postgres_connector()

secondary_db <- Sys.getenv('POSTGRES_DB')
secondary_user <- Sys.getenv('POSTGRES_USER')
secondary_password <- Sys.getenv('POSTGRES_PASSWORD')
secondary_host <- Sys.getenv('POWEREDGE')
secondary_port <- Sys.getenv('POSTGRES_PORT')

sql_query <-
  list(
    "drop table if exists poweredge_meta_statistics",
    "
    create table public.poweredge_meta_statistics  (
        key varchar not null,
        type varchar,
        value numeric,
        primary key (type)
    );
    ",
    glue("SELECT dblink_connect('myconn', 'hostaddr={secondary_host} port={secondary_port} dbname={secondary_db} user={secondary_user} password={secondary_password}');"),
    "with remote_table as (
        select * from dblink('myconn','select key, type, value from meta_statistics')
            as remote(key varchar, type varchar, value numeric)
    )
    insert into public.poweredge_meta_statistics (key, type, value)
    select * from remote_table x on conflict(type) do update set type=excluded.type;"
  )

map(
  sql_query,
  ~ dbExecute(conn = con, sql(.))
)
