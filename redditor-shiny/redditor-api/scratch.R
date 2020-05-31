library(redditor)

reddit_con <- reddit_connector()

response <-
  build_submission_stack(permalink = "/r/SeriousConversation/comments/gteetu/you_know_what_would_significantly_impact_police/")

summarise_thread_stack(response) %>%
  arrange(desc(engagement_ratio))

# response %>%
#   mutate(created_utc = with_tz(floor_date(ymd_hms(created_utc), 'hour'), 'MST')+1) %>%
#   group_by(thread_number, created_utc) %>%
#   summarise(n_observations = n())  %>%
#   group_by(thread_number) %>%
#   mutate(n_obs = n()) %>%
#   filter(n_obs > 1) %>%
#   ggplot() +
#   aes(x = created_utc, y = n_observations) %>%
#   geom_line() +
#   theme(legend.position = "none") +
#   facet_wrap(~ thread_number)


# response %>%
#   filter(thread_number=='thread_number_34')
