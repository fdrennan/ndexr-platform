drop materialized view if exists public.mat_submissions_by_second;
-- SPLIT
create materialized view public.mat_submissions_by_second as (
    select created_utc, count(*) as n_observations
    from public.stream_submissions_all
    group by created_utc
    order by created_utc desc
);
-- SPLIT
drop materialized view if exists public.mat_comments_by_second;
-- SPLIT
create materialized view public.mat_comments_by_second as (
    select created_utc, count(*) as n_observations
    from public.streamall
    group by created_utc
    order by created_utc desc
);

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
    limit 60*60*12
);
