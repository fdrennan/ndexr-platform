CREATE EXTENSION dblink;

-- create the connection
SELECT dblink_connect('myconn', 'hostaddr=192.168.0.59 port=5432 dbname=postgres user=postgres password=Rockies23');

-- then use the connection
-- select key, type, value
-- from meta_statistics local
-- union
create table public.poweredge_meta_statistics  (
        key varchar not null,
        type varchar,
        value numeric,
        primary key (type)
);


with remote_table as (
    select * from dblink('myconn','select key, type, value from meta_statistics')
        as remote(key varchar, type varchar, value numeric)
)
insert into public.poweredge_meta_statistics (key, type, value)
select * from remote_table x on conflict(type) do update set type=excluded.type;
