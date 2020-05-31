drop materialized view if exists public.meta_statistics;
create materialized view public.meta_statistics as (
    select 'count' as key, 'submissions' as type, count(*) as value
    from submissions
    union
    select 'count' as key, 'subreddits' as type, count(distinct subreddit) as value
    from submissions
    union
    select 'count' as key, 'authors' as type, count(distinct author) as value
    from submissions
);

drop materialized view if exists public.counts_by_second;
create materialized view public.counts_by_second as (
    select created_utc::timestamp, count(*) as n_observations
    from public.submissions
    group by created_utc::timestamp
    order by created_utc desc
);

refresh materialized view public.meta_statistics;




refresh materialized view public.meta_statistics;

-- 12680190
select count(*)
from submissions


