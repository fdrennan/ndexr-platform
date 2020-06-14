library(redditor)
library(biggr)

# reddit_con <- reddit_connector()
# connection <- postgres_connector()
# submissions <- tbl(connection, in_schema('public', 'submissions'))
# response <- 
#   submissions %>% 
#   group_by(url, author, subreddit) %>% 
#   count(sort = TRUE) %>% 
#   my_collect()
# 
# response %>% 
#   filter(str_detect(url, 'cbc.ca'))

# configure_aws(aws_access_key_id = Sys.getenv("AWS_ACCESS"), aws_secret_access_key = Sys.getenv("AWS_SECRET"), default.region = Sys.getenv("AWS_REGION"))
# response <-
# build_submission_stack(permalink = "/r/SeriousConversation/comments/gteetu/you_know_what_would_significantly_impact_police/")
# comment_gather_on <- function(key = 'protest') {
#   con <- postgres_connector()
#   on.exit(dbDisconnect(conn = con))
#   gf <-
#     submissions <- tbl(con, in_schema('public', 'submissions')) %>%
#     filter(sql('created_utc::timestamptz') <= local(Sys.Date() - 3)) %>%
#     filter(str_detect(str_to_lower(selftext), key)) %>%
#     my_collect()
#
#   walk(gf$permalink, build_submission_stack)
# }
#
# comment_gather_on(



# walk2(files, resp$key, ~ download.file(url = .x, destfile = .y))
# 