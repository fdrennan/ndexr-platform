-- In airflow DB
create user postgres WITH PASSWORD 'Rockies23';
alter user postgres with superuser;

select count(*)
from public.streamall