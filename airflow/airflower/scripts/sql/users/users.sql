-- In airflow DB
create user postgres WITH PASSWORD 'Rockies23';
alter user postgres with superuser;

create user sprabhu WITH PASSWORD 'K09UjsyQgGGqdlX'
GRANT CONNECT ON DATABASE postgres TO sprabhu;

GRANT USAGE ON SCHEMA public TO sprabhu;
GRANT USAGE ON SCHEMA public TO ppereira;
GRANT USAGE ON SCHEMA public TO cpayne;
GRANT USAGE ON SCHEMA public TO nlamarre;

select count(*)
from public.streamall