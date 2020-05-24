select subreddit_id || '_' || author || '_' || id as submission_key, *
from public.submissions
limit 10

select subreddit_id || '-' || author || '-' || id as submission_key,
       created_utc,
       author, author_fullname, author_premium, author_patreon_flair, can_gild, can_mod_post, clicked, comment_limit, created, downs, edited, fullname, gilded, hidden, hide_score, id, is_crosspostable, is_meta, is_original_content, is_reddit_media_domain, is_robot_indexable, is_self, is_video, locked, media_only, name, no_follow, over_18, permalink, pinned, quarantine, saved, selftext, shortlink, subreddit, subreddit_id, subreddit_name_prefixed, subreddit_subscribers, subreddit_type, thumbnail, title, url
from public.stream_submissions_all
limit 10

INSERT INTO public.submissions(submission_key, created_utc, author, author_fullname,
author_premium, author_patreon_flair, can_gild, can_mod_post,
clicked, comment_limit, created, downs, edited, fullname,
gilded, hidden, hide_score, id, is_crosspostable, is_meta,
is_original_content, is_reddit_media_domain, is_robot_indexable,
is_self, is_video, locked, media_only, name, no_follow,
over_18, permalink, pinned, quarantine, saved, selftext,
shortlink, subreddit, subreddit_id, subreddit_name_prefixed,
subreddit_subscribers, subreddit_type, thumbnail, title,
url)
SELECT distinct subreddit_id || '-' || author || '-' || id as submission_key, created_utc, author, author_fullname,
author_premium, author_patreon_flair, can_gild, can_mod_post,
clicked, comment_limit, created, downs, edited, fullname,
gilded, hidden, hide_score, id, is_crosspostable, is_meta,
is_original_content, is_reddit_media_domain, is_robot_indexable,
is_self, is_video, locked, media_only, name, no_follow,
over_18, permalink, pinned, quarantine, saved, selftext,
shortlink, subreddit, subreddit_id, subreddit_name_prefixed,
subreddit_subscribers, subreddit_type, thumbnail, title,
url
FROM public.submissions_back