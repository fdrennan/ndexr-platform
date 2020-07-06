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
-- SPLIT
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
-- SPLIT
drop materialized view if exists public.counts_by_second;
-- SPLIT
create materialized view public.counts_by_second as (
    select created_utc::timestamp, count(*) as n_observations
    from public.submissions
    group by created_utc::timestamp
    order by created_utc desc
    limit 60*60*12
);
-- SPLIT
drop materialized view if exists public.counts_by_minute;
-- SPLIT
create materialized view public.counts_by_minute as (
    select date_trunc('minute', created_utc::timestamp) as created_utc, count(*) as n_observations
    from public.submissions
    group by date_trunc('minute', created_utc::timestamp)
    order by date_trunc('minute', created_utc::timestamp) desc
    limit 60*48*2
);
-- SPLIT
drop materialized view if exists author_summary;
-- SPLIT
create materialized view author_summary as (
    with cleanup as (
        select author,
               created_utc::timestamptz,
               subreddit,
               url,
               thumbnail,
               title,
               case when lower(author_premium) = 'true' then 1 else 0 end as author_premium,
               case when lower(author_patreon_flair) = 'true' then 1 else 0 end as author_patreon_flair,
               case when lower(can_mod_post) = 'true' then 1 else 0 end as can_mod_post,
               case when lower(is_original_content) = 'true' then 1 else 0 end as is_original_content,
               case when lower(is_reddit_media_domain) = 'true' then 1 else 0 end as is_reddit_media_domain,
               case when lower(is_robot_indexable) = 'true' then 1 else 0 end as is_robot_indexable,
               case when lower(is_self) = 'true' then 1 else 0 end as is_self,
               case when lower(is_video) = 'true' then 1 else 0 end as is_video,
               case when lower(no_follow) = 'true' then 1 else 0 end as no_follow,
               case when lower(over_18) = 'true' then 1 else 0 end as over_18
        from public.submissions
    )

    select author,
           author ilike '%bot' as author_name_ends_with_bot,
           count(distinct date_trunc('day', created_utc)) as n_days,
           min(created_utc) as first_observation,
           max(created_utc) as most_recent_observation,
           count(distinct date_trunc('hour', created_utc)) as n_hour,
           count(distinct subreddit) as n_subreddits,
           count(distinct url) as n_urls,
           count(distinct thumbnail) as n_thumbnails,
           count(distinct title) as n_title,
           sum(author_premium) as author_premium,
           sum(author_patreon_flair) as author_patreon_flair,
           sum(can_mod_post) as can_mod_post,
           sum(is_original_content) as sum_is_original_content,
           sum(is_reddit_media_domain) as is_reddit_media_domain,
           sum(is_robot_indexable) as is_robot_indexable,
           sum(is_self) as is_self,
           sum(is_video) as is_video,
           sum(no_follow) as no_follow,
           sum(over_18) as over_18,
           count(*) as n_submissions
    from cleanup
    group by author
    order by author
);

-- SPLIT
drop materialized view if exists subreddit_summary;
-- SPLIT
create materialized view subreddit_summary as (
    with cleanup as (
        select author,
               created_utc::timestamptz,
               subreddit,
               url,
               thumbnail,
               title,
               case when lower(author_premium) = 'true' then 1 else 0 end as author_premium,
               case when lower(author_patreon_flair) = 'true' then 1 else 0 end as author_patreon_flair,
               case when lower(can_mod_post) = 'true' then 1 else 0 end as can_mod_post,
               case when lower(is_original_content) = 'true' then 1 else 0 end as is_original_content,
               case when lower(is_reddit_media_domain) = 'true' then 1 else 0 end as is_reddit_media_domain,
               case when lower(is_robot_indexable) = 'true' then 1 else 0 end as is_robot_indexable,
               case when lower(is_self) = 'true' then 1 else 0 end as is_self,
               case when lower(is_video) = 'true' then 1 else 0 end as is_video,
               case when lower(no_follow) = 'true' then 1 else 0 end as no_follow,
               case when lower(over_18) = 'true' then 1 else 0 end as over_18
        from public.submissions
    )

    select subreddit,
           count(distinct date_trunc('day', created_utc)) as n_days,
           min(created_utc) as first_observation,
           max(created_utc) as most_recent_observation,
           count(distinct date_trunc('hour', created_utc)) as n_hour,
           count(distinct author) as n_authors,
           count(distinct url) as n_urls,
           count(distinct thumbnail) as n_thumbnails,
           count(distinct title) as n_title,
           sum(author_premium) as author_premium,
           sum(author_patreon_flair) as author_patreon_flair,
           sum(can_mod_post) as can_mod_post,
           sum(is_original_content) as sum_is_original_content,
           sum(is_reddit_media_domain) as is_reddit_media_domain,
           sum(is_robot_indexable) as is_robot_indexable,
           sum(is_self) as is_self,
           sum(is_video) as is_video,
           sum(no_follow) as no_follow,
           sum(over_18) as over_18,
           count(*) as n_submissions
    from cleanup
    group by subreddit
    order by subreddit
);

-- SPLIT
drop materialized view if exists public.urls_summary;
-- SPLIT
create materialized view public.urls_summary as (
with cleanup as (
        select author,
               date_trunc('day', created_utc::timestamptz) as floor_day,
               created_utc::timestamptz,
               subreddit,
               url,
               thumbnail,
               title,
               case when lower(author_premium) = 'true' then 1 else 0 end as author_premium,
               case when lower(author_patreon_flair) = 'true' then 1 else 0 end as author_patreon_flair,
               case when lower(can_mod_post) = 'true' then 1 else 0 end as can_mod_post,
               case when lower(is_original_content) = 'true' then 1 else 0 end as is_original_content,
               case when lower(is_reddit_media_domain) = 'true' then 1 else 0 end as is_reddit_media_domain,
               case when lower(is_robot_indexable) = 'true' then 1 else 0 end as is_robot_indexable,
               case when lower(is_self) = 'true' then 1 else 0 end as is_self,
               case when lower(is_video) = 'true' then 1 else 0 end as is_video,
               case when lower(no_follow) = 'true' then 1 else 0 end as no_follow,
               case when lower(over_18) = 'true' then 1 else 0 end as over_18
        from public.submissions
    )

    select url,
           substring(url from '(?:\w+\.)+\w+') as host_name,
           count(distinct date_trunc('day', created_utc)) as n_days,
           min(created_utc) as first_observation,
           max(created_utc) as most_recent_observation,
           count(distinct date_trunc('hour', created_utc)) as n_hour,
           count(distinct author) as n_authors,
           count(distinct url) as n_urls,
           count(distinct thumbnail) as n_thumbnails,
           count(distinct title) as n_title,
           sum(author_premium) as author_premium,
           sum(author_patreon_flair) as author_patreon_flair,
           sum(can_mod_post) as can_mod_post,
           sum(is_original_content) as sum_is_original_content,
           sum(is_reddit_media_domain) as is_reddit_media_domain,
           sum(is_robot_indexable) as is_robot_indexable,
           sum(is_self) as is_self,
           sum(is_video) as is_video,
           sum(no_follow) as no_follow,
           sum(over_18) as over_18,
           count(*) as n_submissions
    from cleanup
    group by url
    order by url
)

-- SPLIT
drop materialized view if exists public.urls_summary_day;
-- SPLIT
create materialized view public.urls_summary_day as (
with cleanup as (
        select author,
               date_trunc('day', created_utc::timestamptz) as floor_day,
               created_utc::timestamptz,
               subreddit,
               url,
               thumbnail,
               title,
               case when lower(author_premium) = 'true' then 1 else 0 end as author_premium,
               case when lower(author_patreon_flair) = 'true' then 1 else 0 end as author_patreon_flair,
               case when lower(can_mod_post) = 'true' then 1 else 0 end as can_mod_post,
               case when lower(is_original_content) = 'true' then 1 else 0 end as is_original_content,
               case when lower(is_reddit_media_domain) = 'true' then 1 else 0 end as is_reddit_media_domain,
               case when lower(is_robot_indexable) = 'true' then 1 else 0 end as is_robot_indexable,
               case when lower(is_self) = 'true' then 1 else 0 end as is_self,
               case when lower(is_video) = 'true' then 1 else 0 end as is_video,
               case when lower(no_follow) = 'true' then 1 else 0 end as no_follow,
               case when lower(over_18) = 'true' then 1 else 0 end as over_18
        from public.submissions
    )

    select url,
           floor_day,
           substring(url from '(?:\w+\.)+\w+') as host_name,
           count(distinct date_trunc('day', created_utc)) as n_days,
           min(created_utc) as first_observation,
           max(created_utc) as most_recent_observation,
           count(distinct date_trunc('hour', created_utc)) as n_hour,
           count(distinct author) as n_authors,
           count(distinct url) as n_urls,
           count(distinct thumbnail) as n_thumbnails,
           count(distinct title) as n_title,
           sum(author_premium) as author_premium,
           sum(author_patreon_flair) as author_patreon_flair,
           sum(can_mod_post) as can_mod_post,
           sum(is_original_content) as sum_is_original_content,
           sum(is_reddit_media_domain) as is_reddit_media_domain,
           sum(is_robot_indexable) as is_robot_indexable,
           sum(is_self) as is_self,
           sum(is_video) as is_video,
           sum(no_follow) as no_follow,
           sum(over_18) as over_18,
           count(*) as n_submissions
    from cleanup
    group by url, floor_day
    order by floor_day desc, n_submissions desc
)