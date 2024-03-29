CREATE TABLE if not exists public.streamall
(
    author                varchar,
    author_fullname       varchar,
    author_patreon_flair  boolean,
    author_premium        boolean,
    body                  varchar,
    can_gild              boolean,
    can_mod_post          boolean,
    controversiality      integer,
    created               integer,
    created_utc           timestamptz,
    depth                 varchar,
    downs                 integer,
    fullname              varchar,
    id                    varchar,
    is_root               boolean,
    is_submitter          boolean,
    link_id               varchar,
    name                  varchar,
    no_follow             boolean,
    parent_id             varchar,
    permalink             varchar,
    score                 integer,
    submission            varchar,
    subreddit             varchar,
    subreddit_id          varchar,
    total_awards_received integer,
    ups                   integer,
    time_gathered_utc     timestamptz
);
-- SPLIT
CREATE TABLE if not exists public.stream_submissions_all
(
    author                  varchar,
    author_fullname         varchar,
    author_premium          boolean,
    author_patreon_flair    boolean,
    can_gild                boolean,
    can_mod_post            boolean,
    clicked                 boolean,
    comment_limit           integer,
    created                 integer,
    created_utc             timestamptz,
    downs                   integer,
    edited                  boolean,
    fullname                varchar,
    gilded                  integer,
    hidden                  boolean,
    hide_score              boolean,
    id                      varchar,
    is_crosspostable        boolean,
    is_meta                 boolean,
    is_original_content     boolean,
    is_reddit_media_domain  boolean,
    is_robot_indexable      boolean,
    is_self                 boolean,
    is_video                boolean,
    locked                  boolean,
    media_only              boolean,
    name                    varchar,
    no_follow               boolean,
    over_18                 boolean,
    permalink               varchar,
    pinned                  boolean,
    quarantine              boolean,
    saved                   boolean,
    selftext                varchar,
    shortlink               varchar,
    subreddit               varchar,
    subreddit_id            varchar,
    subreddit_name_prefixed varchar,
    subreddit_subscribers   integer,
    subreddit_type          varchar,
    thumbnail               varchar,
    title                   varchar,
    url                     varchar
);
-- SPLIT
CREATE TABLE if not exists public.submissions_top
(
    submission_key          varchar primary key,
    created_utc             varchar,
    author                  varchar,
    author_fullname         varchar,
    author_premium          varchar,
    author_patreon_flair    varchar,
    can_gild                varchar,
    can_mod_post            varchar,
    clicked                 varchar,
    comment_limit           integer,
    created                 integer,
    downs                   integer,
    edited                  varchar,
    fullname                varchar,
    gilded                  varchar,
    hidden                  varchar,
    hide_score              varchar,
    id                      varchar,
    is_crosspostable        varchar,
    is_meta                 varchar,
    is_original_content     varchar,
    is_reddit_media_domain  varchar,
    is_robot_indexable      varchar,
    is_self                 varchar,
    is_video                varchar,
    locked                  varchar,
    media_only              varchar,
    name                    varchar,
    no_follow               varchar,
    over_18                 varchar,
    permalink               varchar,
    pinned                  varchar,
    quarantine              varchar,
    saved                   varchar,
    selftext                varchar,
    shortlink               varchar,
    subreddit               varchar,
    subreddit_id            varchar,
    subreddit_name_prefixed varchar,
    subreddit_subscribers   varchar,
    subreddit_type          varchar,
    thumbnail               varchar,
    title                   varchar,
    url                     varchar
);

-- SPLIT
-- drop table if exists public.comments
CREATE TABLE if not exists public.comments
(
    comment_key           varchar primary key,
    author                varchar,
    author_fullname       varchar,
    author_patreon_flair  varchar,
    author_premium        varchar,
    body                  varchar,
    can_gild              varchar,
    can_mod_post          varchar,
    controversiality      varchar,
    created               varchar,
    created_utc           varchar,
    depth                 varchar,
    downs                 varchar,
    fullname              varchar,
    id                    varchar,
    is_root               varchar,
    is_submitter          varchar,
    link_id               varchar,
    name                  varchar,
    no_follow             varchar,
    parent_id             varchar,
    permalink             varchar,
    score                 varchar,
    submission            varchar,
    subreddit             varchar,
    subreddit_id          varchar,
    total_awards_received varchar,
    ups                   varchar,
    time_gathered_utc     varchar
);
-- SPLIT
CREATE TABLE if not exists public.comments_to_word
(
    token_key   varchar primary key,
    comment_key varchar,
    submission  varchar,
    author      varchar,
    subreddit   varchar,
    sentence_id varchar,
    token_id    varchar,
    token       varchar,
    lemma       varchar,
    pos         varchar,
    entity      varchar
);
-- SPLIT
CREATE TABLE if not exists public.poweredge_meta_statistics
(
    key   varchar not null,
    type  varchar,
    value numeric,
    primary key (type)
);

CREATE TABLE if not exists public.costs
(
    start          date,
    unblended_cost numeric,
    blended_cost   numeric,
    usage_quantity numeric,
    primary key (start)
);
-- SPLIT
CREATE TABLE if not exists public.submissions
(
    submission_key          varchar,
    created_utc             varchar,
    author                  varchar,
    author_fullname         varchar,
    author_premium          varchar,
    author_patreon_flair    varchar,
    can_gild                varchar,
    can_mod_post            varchar,
    clicked                 varchar,
    comment_limit           varchar,
    created                 varchar,
    downs                   varchar,
    edited                  varchar,
    fullname                varchar,
    gilded                  varchar,
    hidden                  varchar,
    hide_score              varchar,
    id                      varchar,
    is_crosspostable        varchar,
    is_meta                 varchar,
    is_original_content     varchar,
    is_reddit_media_domain  varchar,
    is_robot_indexable      varchar,
    is_self                 varchar,
    is_video                varchar,
    locked                  varchar,
    media_only              varchar,
    name                    varchar,
    no_follow               varchar,
    over_18                 varchar,
    permalink               varchar,
    pinned                  varchar,
    quarantine              varchar,
    saved                   varchar,
    selftext                varchar,
    shortlink               varchar,
    subreddit               varchar,
    subreddit_id            varchar,
    subreddit_name_prefixed varchar,
    subreddit_subscribers   varchar,
    subreddit_type          varchar,
    thumbnail               varchar,
    title                   varchar,
    url                     varchar,
    primary key (submission_key)
)
--SPLIT
create table if not exists public.detect_roze
(
    author varchar,
    url varchar,
    submission_key varchar,
    detected_roze varchar,
    primary key (submission_key)
)

create view public.roze as (
    with you_tube_videos as (
        select submission_key, author, url
        from submissions
        where url ilike '%youtube%'
    ), x as (
        select ytv.submission_key, ytv.author, dr.detected_roze
        from you_tube_videos ytv
        left join detect_roze dr on ytv.submission_key=dr.submission_key
    )

    select *
    from x
)

