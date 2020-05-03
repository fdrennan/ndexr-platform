drop view if exists public.stream_comments;
create view public.stream_comments as (
    select created_utc, subreddit, author, body, permalink, parent_id, name, link_id, id
    from public.streamall
    order by created_utc desc, subreddit, author
);

drop view if exists public.stream_submissions;
create view public.stream_submissions as (
    select created_utc, subreddit, author, title, selftext, permalink, shortlink, name, thumbnail, url
    from public.stream_submissions_all
);

select created_utc, count(*) as n_obs
from (
     select date_round(created_utc, '5 minutes') as created_utc
from public.streamall

         ) x
group by created_utc
order by created_utc desc



select count(*)
from public.streamall
-- /var/lib/postgresql/data