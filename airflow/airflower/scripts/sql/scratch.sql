select *
from public.submissions
where created_utc::timestamptz <= now() - interval '3 days'
-- order by random()
limit 10


select subreddit_id, *
from public.comments


select distinct submission_key, s.author, s.subreddit, s.created_utc, over_18, selftext, shortlink,
                thumbnail, title, url
from public.submissions s
lt join public.comments c on s.fullname=c.link_id
where s.fullname = 't3_gtu6e5'

delete from public.submissions where date_trunc('days', created_utc::timestamptz) = '2020-05-03'
select min(created_utc) from public.submissions