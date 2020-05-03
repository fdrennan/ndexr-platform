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
