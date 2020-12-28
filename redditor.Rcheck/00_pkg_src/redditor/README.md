# INSTALLATION GUIDE

`redditor` is a wrapper for the `praw` library in Python, so we need to do some configuration to get R working with reticulate. Listen, reticulate can be a headache. So, if you have issues, please let me know. We can both update the documentation as well as get you up and running. 

# Installing in RServer

```
install.packages(c('devtools', 'roxygen2',
                   'tidyverse','reticulate',
                   'RPostgres','DBI','dbplyr',
                   'rvest','lubridate','tidytext',
                   'tictoc','elasticsearchr','dbx',
                   'ggthemes','shinydashboard',
                   'shiny','openxlsx','spacyr',
                   'quanteda','uuid'))

# Build the R package and load
library(redditor)

reticulate::install_miniconda()

conda_install(packages = c("praw", "spacy"))
spacy_download_langmodel(envname = 'r-reticulate')
```

# AFTER RUNNING THE CODE BELOW WITH YOUR ASSOCIATED ENVIRONMENT VARIABLES, RESTART YOUR R SESSION

# RUNNING THE SOFTWARE

```
devtools::install_github('fdrennan/redditor')

library(redditor)

praw = reticulate::import('praw')

reddit_con = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                         client_secret=Sys.getenv('REDDIT_AUTH'),
                         user_agent=Sys.getenv('USER_AGENT'),
                         username=Sys.getenv('USERNAME'),
                         password=Sys.getenv('PASSWORD'))

resp <-
  get_user_comments(
    reddit = reddit_con,
    user = 'spez',
    type = 'top',
    limit = 10
  )


subreddit <-
  get_subreddit(
    reddit = reddit_con,
    name = 'politics',
    type = 'hot',
    limit = 3
  )
  

reddit_by_url <-
  get_url(
    reddit = reddit_con,
    url = 'https://www.reddit.com/r/TwoXChromosomes/comments/g3t7yj/to_the_woman_who_yelled_to_me_from_across_the/'
  )

```

# BUILDING A BOT TO REPLY TO A COMMENT
```
# Building a bot
# ndexr is my subreddit - have at it if you want to mess around
# Here, we iterate over existing comments as well as new ones as the come in
ndexr <- reddit$subreddit('ndexr')
iterate(ndexr$stream$comments(), function(x) {
  if(str_detect(x$body, 'googleit')) {
    google_search <- str_trim(str_remove(x$body, "^.*]"))
    google_search <- str_replace_all(google_search, " ", "+")
    lmgtfy <- glue('https://lmgtfy.com/?q={google_search}')
    x$reply(lmgtfy)
  }
})
```

# DOING SOMETHING WITH STREAMS
```
# Do something with comments
parse_comments_wrapper <- function(x) {
  submission_value <- parse_comments(x)
  glimpse(submission_value)
}
stream_comments(reddit_con, 'politics', parse_comments_wrapper)


# Do something with submissions
parse_submission_wrapper <- function(x) {
  submission_value <- parse_meta(x)
  glimpse(submission_value)
}
stream_submission(reddit_con, 'politics', parse_submission_wrapper)

# Store everything
parse_comments_wrapper <- function(x) {
  submission_value <- parse_comments(x)
  if(!file_exists('stream.csv')) {
    write_csv(x = submission_value, path = 'stream.csv', append = FALSE)
  } else {
    write_csv(x = submission_value, path = 'stream.csv', append = TRUE)
  }
  print(now(tzone = 'UTC') - submission_value$created_utc)
}

stream_comments(reddit_con, 'all', parse_comments_wrapper)

```

```
library(redditor)
library(biggr)

praw = reticulate::import('praw')

reddit_con = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                         client_secret=Sys.getenv('REDDIT_AUTH'),
                         user_agent=Sys.getenv('USER_AGENT'),
                         username=Sys.getenv('USERNAME'),
                         password=Sys.getenv('PASSWORD'))

sns_send_message(phone_number=Sys.getenv('MY_PHONE'), message='Running gathering')

# Do something with comments
parse_comments_wrapper <- function(x) {
  submission_value <- parse_comments(x)
  write_csv(x = submission_value, path = 'stream.csv', append = TRUE)
  print(now(tzone = 'UTC') - submission_value$created_utc)
}

stream_comments(reddit = reddit_con,
                subreddit =  'all',
                callback =  parse_comments_wrapper)

```
