#' @export get_user_comments
get_user_comments <- function(reddit = NULL, user = NULL, type = "top", limit = NULL) {
  user <- reddit$redditor(user)$comments

  user <- switch(
    type,
    "controversial" = {
      user$controversial(limit = limit)
    },
    "hot" = {
      user$hot(limit = limit)
    },
    "new" = {
      user$new(limit = limit)
    },
    "top" = {
      user$top(limit = limit)
    },
  )

  comments <- iterate(user)

  colz <- c(
    "archived",
    "author",
    "author_fullname",
    "author_premium",
    "body",
    "can_guild",
    "can_mod_post",
    "controversality",
    "created",
    "created_utc",
    "downs",
    "edited",
    "fullname",
    "gilded",
    "id",
    "id_from_url",
    "is_root",
    "is_submitter",
    "likes",
    "link_author",
    "link_id",
    "link_permalink",
    "link_title",
    "link_url",
    "locked",
    "MISSING_COMMENT_MESSAGE",
    "name",
    "no_follow",
    "num_comments",
    "over_18",
    "parent_id",
    "permalink",
    "quarantine",
    "score",
    "score_hidden",
    "send_replies",
    "stickied",
    "STR_FIELD",
    "submission",
    "subreddit",
    "subreddit_id",
    "subreddit_name_prefixed",
    "subreddit_type",
    "total_awards_received",
    "ups"
  )

  resp <-
    map_df(
      comments,
      function(z) {
        resp <- map_df(
          colz,
          function(x) {
            value <-
              tryCatch(expr = {
                as.character(z[[x]])
              }, error = function(e) {
                return("")
              })
            resp <- tibble(
              type = x,
              value = value
            )
            resp
          }
        )
        ret_data <- as_tibble(t(resp$value), .name_repair = "minimal")
        colnames(ret_data) <- resp$type

        ret_data %>%
          mutate(
            archived = as.logical(archived),
            author_premium = as.logical(author_premium),
            can_mod_post = as.logical(can_mod_post),
            created = as.numeric(created),
            created_utc = as.POSIXct(x = as.numeric(created_utc), origin = "1970-01-01", tz = "UTC"),
            downs = as.numeric(downs),
            edited = as.logical(edited),
            is_root = as.logical(is_root),
            is_submitter = as.logical(is_submitter),
            locked = as.logical(locked),
            no_follow = as.logical(no_follow),
            num_comments = as.numeric(num_comments),
            over_18 = as.logical(over_18),
            quarantine = as.logical(quarantine),
            score = as.numeric(score),
            score_hidden = as.logical(score_hidden),
            send_replies = as.logical(send_replies),
            stickied = as.logical(stickied),
            total_awards_recieved = as.numeric(total_awards_received),
            ups = as.numeric(ups),
            time_gathered_utc = now(tzone = "UTC")
          )
      }
    )
}

#' @export parse_meta
parse_meta <- function(subreddit_data) {
  chosen_columns <- c(
    "author",
    "author_fullname",
    "author_premium",
    "author_patreon_flair",
    "can_gild",
    "can_mod_post",
    "clicked",
    "comment_limit",
    "created",
    "created_utc",
    "downs",
    "edited",
    "fullname",
    "gilded",
    "hidden",
    "hide_score",
    "id",
    "is_crosspostable",
    "is_meta",
    "is_original_content",
    "is_reddit_media_domain",
    "is_robot_indexable",
    "is_self",
    "is_video",
    "locked",
    "media_only",
    "name",
    "no_follow",
    # 'num_comments',
    # 'num_crossposts',
    # 'num_duplicates',
    "over_18",
    # 'parent_whitelist_status',
    "permalink",
    "pinned",
    # 'pwls',
    "quarantine",
    "saved",
    # 'score',
    "selftext",
    # 'send_replies',
    "shortlink",
    # 'spoiler',
    # 'stickied',
    "subreddit",
    "subreddit_id",
    "subreddit_name_prefixed",
    "subreddit_subscribers",
    "subreddit_type",
    "thumbnail",
    "title",
    # 'total_awards_received',
    # 'ups',
    # 'upvote_ratio',
    "url"
  )

  meta_data <- as_tibble(t(tibble(map_chr(chosen_columns, function(x) {
    tryCatch(
      {
        as.character(subreddit_data[[x]])
      },
      error = function() {
        return("")
      }
    )
  }))), .name_repair = "minimal")

  colnames(meta_data) <- chosen_columns

  meta_data %>%
    mutate_at(vars(starts_with("num")), as.numeric) %>%
    mutate_at(vars(starts_with("is")), as.logical) %>%
    mutate(
      created_utc = as.POSIXct(x = as.numeric(created_utc), origin = "1970-01-01", tz = "UTC")
    )
  # %>%
  #   mutate(
  #     author_premium = as.logical(author_premium),
  #     author_patreon_flair = as.logical(author_patreon_flair),
  #     # can_gild = as.logical(can_gild),
  #     can_mod_post = as.logical(can_mod_post),
  #     clicked = as.logical(clicked),
  #     comment_limit = as.numeric(comment_limit),
  #     created = as.numeric(created),
  #     ,
  #     downs = as.numeric(downs),
  #     edited = as.logical(edited),
  #     # gilded = as.numeric(gilded),
  #     hidden = as.logical(hidden),
  #     hide_score = as.logical(hide_score),
  #     locked = as.logical(locked),
  #     media_only = as.logical(media_only),
  #     no_follow = as.logical(no_follow),
  #     over_18 = as.logical(over_18),
  #     # pwls = as.numeric(pwls),
  #     quarantine = as.logical(quarantine),
  #     saved = as.logical(saved),
  #     score = as.numeric(score),
  #     send_replies = as.logical(send_replies),
  #     spoiler = as.logical(spoiler),
  #     stickied = as.logical(stickied),
  #     subreddit_subscribers = as.numeric(subreddit_subscribers),
  #     total_awards_received = as.numeric(total_awards_received),
  #     ups = as.numeric(ups),
  #     upvote_ratio = as.numeric(upvote_ratio)
  # visited = as.logical(visited)
  # )
}

#' @export get_url
get_url <- function(reddit, url) {
  sub <- reddit$submission(url = url)

  meta_data <- parse_meta(sub)

  comments <-
    map_df(
      # head(iterate(subreddit$hot()),1),
      list(sub),
      function(x) {
        map_df(x$comments$list(), function(x) {
          parse_comments(x)
        })
      }
    )

  list(meta_data = meta_data, comments = comments)
}

#' @export parse_comments
parse_comments <- function(comment_data, stream = FALSE) {
  if (stream) {
    chosen_columns <-
      c(
        "author",
        "author_fullname",
        "author_patreon_flair",
        "author_premium",
        "body",
        "can_gild",
        "can_mod_post",
        "created",
        "created_utc",
        "depth",
        "fullname",
        "id",
        "is_root",
        "is_submitter",
        "link_id",
        "name",
        "no_follow",
        "parent_id",
        "permalink",
        "submission",
        "subreddit",
        "subreddit_id"
      )
  } else {
    chosen_columns <-
      c(
        "author",
        "author_fullname",
        "author_patreon_flair",
        "author_premium",
        "body",
        "can_gild",
        "can_mod_post",
        "controversiality",
        "created",
        "created_utc",
        "depth",
        "downs",
        "fullname",
        "id",
        "is_root",
        "is_submitter",
        "link_id",
        "name",
        "no_follow",
        "parent_id",
        "permalink",
        "score",
        "submission",
        "subreddit",
        "subreddit_id",
        "total_awards_received",
        "ups"
      )
  }


  resp <- map_chr(chosen_columns, function(z) {
    resp <-
      tryCatch(
        expr = {
          comment_data[[z]]
        },
        error = function(e) {
          return("")
        }
      )

    if (length(resp) == 0) {
      return("")
    }

    as.character(resp)
  })

  response <- as_tibble(t(resp), .name_repair = "minimal")
  colnames(response) <- chosen_columns

  response %>%
    mutate(
      author_patreon_flair = as.logical(author_patreon_flair),
      author_premium = as.logical(author_premium),
      can_gild = as.logical(can_gild),
      can_mod_post = as.logical(can_mod_post),
      controversiality = as.numeric(controversiality),
      created = as.numeric(created),
      created_utc = as.POSIXct(x = as.numeric(created_utc), origin = "1970-01-01", tz = "UTC"),
      depth = as.numeric(depth),
      downs = as.numeric(downs),
      is_root = as.logical(is_root),
      is_submitter = as.logical(is_submitter),
      no_follow = as.logical(no_follow),
      score = as.numeric(score),
      total_awards_received = as.numeric(total_awards_received),
      ups = as.numeric(ups),
      time_gathered_utc = now(tzone = "UTC")
    )
}


#' @export get_subreddit
get_subreddit <- function(reddit = NULL, name = NULL, type = NULL, limit = 10) {
  subreddit <- subreddit <- reddit$subreddit(name)

  subreddit <- switch(
    type,
    "controversial" = {
      subreddit$controversial(limit = limit)
    },
    "hot" = {
      subreddit$hot(limit = limit)
    },
    "new" = {
      subreddit$new(limit = limit)
    },
    "top" = {
      subreddit$top(limit = limit)
    },
  )

  comments <- iterate(subreddit)

  meta_data <- map_df(comments, ~ parse_meta(.))

  comments <-
    map_df(
      comments,
      function(x) {
        map_df(x$comments$list(), function(x) {
          parse_comments(x)
        })
      }
    )

  list(meta_data = meta_data, comments = comments)
}

#' @export subreddit_profile
subreddit_profile <- function(subreddit_name = NULL) {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))
  user_subreddits <-
    con %>%
    tbl(in_schema("public", "user_subreddits"))

  nsfw_rating <-
    con %>%
    tbl(in_schema("public", "nsfw_rating"))


  reddit_authors <-
    user_subreddits %>%
    filter(subreddit == subreddit_name) %>%
    distinct(author)


  most_frequented_subreddits <-
    user_subreddits %>%
    inner_join(reddit_authors) %>%
    group_by(subreddit) %>%
    count(name = "n_obs") %>%
    ungroup() %>%
    inner_join(nsfw_rating) %>%
    select(subreddit, n_obs, pct_nsfw) %>%
    mutate_if(is.numeric, as.numeric) %>%
    arrange(desc(n_obs)) %>%
    mutate(rank = row_number()) %>%
    collect()


  most_frequented_subreddits %>%
    as.data.frame()
}
