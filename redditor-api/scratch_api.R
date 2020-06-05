library(redditor)
library(httr)
# resp <- GET(url = glue("http://ndexr.com/api/get_summary"), query = list(table_name = "meta_statistics"))
# meta_statistics <- fromJSON(fromJSON(content(resp, "text"))$data)
# resp <- GET(url = glue("http://ndexr.com/api/get_summary"), query = list(table_name = "counts_by_minute"))
# counts_by_second <- fromJSON(fromJSON(content(resp, "text"))$data)


response <-
  GET(url = glue("http://ndexr.com/api/build_submission_stack"),
    query = list(permalink = '/r/gifs/comments/gu8inv/la_cop_car_rams_protester_on_live_tv_chopper/'))

submission_stack <- fromJSON(fromJSON(content(response, "text"))$data)



submission_stack %>%
  View


summarise_thread_stack(submission_stack) %>%
  arrange(desc(engagement_ratio))


View(submission_stack)


rcon = reddit_connector()
user <- redditor::get_user_comments(reddit = rcon, user = 'Durindael', type = 'top', limit = 900000)


user %>%
  glimpse
