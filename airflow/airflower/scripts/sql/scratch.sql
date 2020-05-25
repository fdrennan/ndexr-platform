with times as (
  select date_trunc('hour', created_utc::timestamptz) as created_utc
  from submissions
)


select created_utc, count(*)::numeric as n_observations
from times
where created_utc >= now() - interval '1 days'
group by created_utc