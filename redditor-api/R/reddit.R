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
        # if(as.character(subreddit_data)=='giy5fv') {
        #   browser()
        # }
        response <- tryCatch(
          {
            as.character(subreddit_data[[x]])
          },
          error = function(err) {
            as.character(err)
          }
        )
        if (is.null(response) | length(response) == 0) {
          return("")
        }
        response
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
get_url <- function(reddit,
                    permalink,
                    store = TRUE,
                    n_seconds = 3,
                    dont_update = TRUE,
                    comments_to_word = TRUE) {

  # if(permalink == '/r/politics/comments/gjoyb9/biden_must_let_a_more_progressive_democratic/') {
  #   browser()
  # }
  message(glue("Grabbing on {permalink} -- {as.character(Sys.time())}"))
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))

  has_value <-
    tbl(con, in_schema("public", "comments")) %>%
    filter(str_detect(str_to_lower(permalink), local(str_to_lower(permalink)))) %>%
    count() %>%
    my_collect()

  if (has_value & dont_update) {
    meta_data <-
      tbl(con, in_schema("public", "submissions")) %>%
      filter(str_detect(str_to_lower(permalink), local(str_to_lower(permalink)))) %>%
      my_collect()
    
    comments <-
      tbl(con, in_schema("public", "comments")) %>%
      filter(str_detect(str_to_lower(permalink), local(str_to_lower(permalink)))) %>%
      my_collect()
    
    message("Skipping, already hit once")
    return(list(meta_data, comments))
  }

  url <- glue("http://reddit.com{permalink}")
  sub <- reddit$submission(url = url)
  meta_data <- tryCatch(
    {
      submission <- parse_meta(sub) %>%
        mutate(
          submission_key = glue("{subreddit_id}_{author}_{name}")
        ) %>%
        select(submission_key, created_utc, everything())
      dbxUpsert(con, "submissions", submission, where_cols = c("submission_key"))
      submission
    },
    error = function(e) {
      message("ERROR")
      message(as.character(e))
      message("Grab meta data failed in {permalink}")
      return(TRUE)
    }
  )

  if (is.logical(meta_data)) {
    return(TRUE)
  }

  comments <-
    tryCatch(
      {
        map(
          list(sub),
          function(x) {
            response <- map_df(x$comments$list(), function(x) {
              resp <- parse_comments(x)
              resp
            })
            response
          }
        )
      },
      error = function(e) {
        message("ERROR")
        message(as.character(e))
        message("parse_comments failed in {permalink}")
        return(TRUE)
      }
    )

  comments <- keep(comments, ~ nrow(.) > 0) %>% bind_rows()
  print(glimpse(comments))
  if (!is.data.frame(comments) | nrow(comments) == 0) {
    return(NULL)
  }

  if (length(comments$author[comments$author == ""]) > 0) {
    comments$author[comments$author == ""] <- map_chr(1:length(comments$author[comments$author == ""]), ~ UUIDgenerate(.))
  }

  comments <-
    comments %>%
    mutate(comment_key = glue("{subreddit_id}-{parent_id}-{id}")) %>%
    select(comment_key, everything())

  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))

  if (store) {
    tryCatch(
      {
        n_comments_before <- dbGetQuery(conn = con, "select count(*) as n_comments from comments")
        dbxUpsert(con, "comments", comments, where_cols = c("comment_key"))
        n_comments_after <- dbGetQuery(conn = con, "select count(*) as n_comments from comments")
        message(glue("Added {as.character(n_comments_after$n_comments - n_comments_before$n_comments)} comments"))
        if (comments_to_word) {
          update_comments_to_word()
        }
        # message(glue("Comments Uploaded: {nrow(comments)}"))
      },
      error = function(e) {
        message("ERROR")
        message(as.character(e))
        message("update_comments_to_word failed in {permalink}")
        return(TRUE)
      }
    )
  }

  Sys.sleep(n_seconds)
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

#' @export get_submission
get_submission <- function(reddit = NULL, name = NULL, type = NULL, limit = 10) {
  subreddit <- reddit$subreddit(name)
  subreddit <- switch(type, controversial = {
    subreddit$controversial(limit = limit)
  }, hot = {
    subreddit$hot(limit = limit)
  }, new = {
    subreddit$new(limit = limit)
  }, top = {
    subreddit$top(limit = limit)
  }, )
  comments <- iterate(subreddit)
  meta_data <- map_df(comments, ~ parse_meta(.))
  meta_data %>%
    mutate(
      submission_key = glue("{subreddit_id}_{author}_{name}")
    ) %>%
    select(submission_key, created_utc, everything())
}

#' @export gather_submissions
gather_submissions <- function(con = con, reddit_con = NULL, forced_sleep_time = 60) {
  while (TRUE) {
    get_all <- get_submission(reddit = reddit_con, name = "all", limit = 1000L, type = "new")
    tryCatch(
      {
        dbxUpsert(con, "submissions", get_all, where_cols = c("submission_key"))
      },
      error = function(e) {
        message("Something went wrong with upsert in gather_submissions, {as.character(Sys.time())}")
      }
    )
    tryCatch(expr = {
      throttle_me(reddit_con)
      Sys.sleep(forced_sleep_time)
    }, error = function(err) {
      send_message("Something went wrong in get_submission's throttle")
      send_message(as.character(err))
    })
  }
}

#' @export upload_subreddit
upload_subreddit <- function(subreddit_name = "politics",
                             n_seconds = 3,
                             comments_to_word = FALSE,
                             n_to_pull = 10) {
  reddit_con <- reddit_connector()
  con <- postgres_connector()

  submissions <-
    tbl(con, in_schema("public", "submissions")) %>%
    filter(subreddit == subreddit_name) %>%
    mutate(
      created_utc = sql("created_utc::timestamptz"),
      submission = id
    ) %>%
    filter(created_utc <= local(now(tzone = "UTC") - days(2))) %>%
    arrange(created_utc)
  # my_collect

  comments <-
    tbl(con, in_schema("public", "comments")) %>%
    transmute(submission, already_run = TRUE) %>%
    distinct()

  response <-
    submissions %>%
    anti_join(comments, by = "submission") %>%
    # filter(is.na(already_run)) %>%
    head(n_to_pull) %>%
    my_collect()

  message(glue("About to run on {nrow(response)} rows"))

  walk(response$permalink, ~ get_url(reddit = reddit_con, permalink = ., n_seconds = n_seconds, comments_to_word = comments_to_word))
}

#' @export comment_thread
comment_thread <- function(submission = NULL, permalink = NULL) {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))

  if (!is.null(permalink)) {
    comments <- tbl(con, in_schema("public", "comments")) %>%
      filter(str_detect(permalink, local(permalink))) %>%
      collect()
  } else {
    comments <- tbl(con, in_schema("public", "comments")) %>%
      filter(str_detect(submission, local(submission))) %>%
      collect()
  }

  comments <-
    comments %>%
    select(id, parent_id, body, everything()) %>%
    my_collect()

  comments
}

#' @export create_submission_thread
create_submission_thread <- function(submission = NULL) {
  submission_parser <-
    submission %>%
    select(link_id, parent_id, id, body) %>%
    mutate(
      parents = str_sub(parent_id, 4, -1)
    )

  end_subs <- map_lgl(submission_parser$id, function(x) {
    !any(str_detect(submission_parser$parent_id, x))
  })

  end_ids <- submission_parser[end_subs, ]$id
  permalink_id <- unique(submission_parser$link_id)
  map(
    end_ids,
    function(x) {
      vector_list <- x
      continue_running <- TRUE
      while (continue_running) {
        parent <- filter(submission_parser, str_detect(id, x))$parents
        if (str_detect(permalink_id, parent)) {
          continue_running <- FALSE
        } else {
          x <- unique(filter(submission_parser, str_detect(parents, parent))$parents)
          vector_list <-
            append(vector_list, x)
        }
      }
      return(rev(vector_list))
    }
  )
}


#' @export summarise_thread_stack
summarise_thread_stack <- function(thread_stack = NULL) {
  thread_stack %>%
    group_by(thread_number, author) %>%
    count(name = "n_observations") %>%
    group_by(thread_number) %>%
    summarise(
      n_authors = n_distinct(author),
      n_observations = sum(n_observations)
    ) %>%
    mutate(
      engagement_ratio = n_observations / n_authors
    )
}

#' @export create_thread_stack
create_thread_stack <- function(threads, comments, min_length = 0) {
  threads <-
    threads %>%
    keep(~ length(.) > min_length)

  threads <-
    threads %>%
    map2_df(
      .,
      1:length(.),
      function(x, y) {
        filter(
          comments,
          id %in% x
        ) %>%
          mutate(thread = y, thread_number = paste0("thread_number_", thread)) %>%
          select(
            thread_number, created_utc, body, author, id, parent_id, everything()
          ) %>%
          arrange(thread_number, created_utc)
      }
    )
  threads
}


#' @export build_submission_stack
build_submission_stack <- function(permalink = NULL) {
  message(permalink)
  reddit_con <- reddit_connector()
  get_url(
    reddit = reddit_con,
    permalink = permalink,
    comments_to_word = FALSE,
    dont_update = TRUE
  )
  comments <- comment_thread(permalink = permalink)
  threads <- create_submission_thread(comments)
  thread_stack <- create_thread_stack(threads, comments, min_length = 0)
  thread_stack
}

#' @export comment_gather_on
comment_gather_on <- function(key = "george floyd") {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))
  gf <-
    submissions <- tbl(con, in_schema("public", "submissions")) %>%
    filter(sql("created_utc::timestamptz") <= local(Sys.Date() - 3)) %>%
    filter(str_detect(str_to_lower(selftext), key)) %>%
    my_collect()

  walk(gf$permalink, build_submission_stack)
}
