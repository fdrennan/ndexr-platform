

create table submissions_spammer_backup as (
    select distinct author, subreddit
from (
     select author, subreddit
from submissions
where author = 'lifedream11'
union
select 'lifedream11' as author, roze_subs as subreddit
from roze_subreddits
         ) x
)