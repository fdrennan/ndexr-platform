-- drop materialized view if exists public.mat_stream_authors;
create materialized view public.mat_stream_authors as (
    select *
    from public.stream_authors
);

create materialized view public.mat_comments_by_second as (
    select created_utc, count(*) as n_observations
    from public.stream_comments
    group by created_utc
    order by created_utc desc
);

create materialized view public.mat_submissions_by_second as (
    select created_utc, count(*) as n_observations
    from public.stream_submissions_all
    group by created_utc
    order by created_utc desc
);


drop materialized view if exists public.streamall_meta_data;
create materialized view public.streamall_meta_data as (

    select 'xdexr' as meta, 'n_authors' as type, count(distinct author)::varchar as amount
    from public.streamall
    union
    select 'xdexr' as meta, 'n_subreddit' as type, count(distinct subreddit)::varchar as amount
    from public.streamall
    union
    select 'subreddit' as meta, subreddit as type, count(*)::varchar as amount
    from public.streamall
    group by subreddit
    union
    select 'time' as meta, 'last_updated' as type, max(created_utc)::varchar as amount
    from public.streamall
    union
    select 'author' as meta, author as type, count(*)::varchar as amount
    from public.streamall
    group by author
    order by meta,  amount desc
);

drop materialized if exists public.stream_submission_meta_data;
create materialized view public.stream_submission_meta_data as (
    select 'xdexr' as meta, 'n_authors' as type, count(distinct author)::varchar as amount
    from public.stream_submissions_all
    union
    select 'xdexr' as meta, 'n_subreddit' as type, count(distinct subreddit)::varchar as amount
    from public.stream_submissions_all
    union
    select 'subreddit' as meta, subreddit as type, count(*)::varchar as amount
    from public.stream_submissions_all
    group by subreddit
    union
    select 'time' as meta, 'last_updated' as type, max(created_utc)::varchar as amount
    from public.stream_submissions_all
    union
    select 'author' as meta, author as type, count(*)::varchar as amount
    from public.stream_submissions_all
    group by author
    order by meta,  amount desc
);

