select max(created_utc::timestamptz)
from public.submissions

-- delete from submissions where created_utc::timestamptz < now() - interval '1 hours'