# Title     : TODO
# Objective : TODO
# Created by: fdrennan
# Created on: 5/14/20

# library(biggr)
# library(ipify)
#
# sgd <- security_group_data()
#
# ips <- sgd %>%
#   filter(group_name == 'Router', from_port == 22)
#
# current_ip <-
#  ips %>%
#    filter(str_detect(ip_ranges, my_ip))
#
# if(nrow(current_ip) == 0) {
#   security_group_revoke(sg_name = 'Router', ports = 22, ips = str_remove_all(ips$ip_ranges, "/32"))
#   my_ip = get_ip()
#   security_group_envoke(sg_name = 'Router', ports = 22, ips = my_ip)
# }

library(biggr)
library(ggplot2)
library(tidyverse)

configure_aws(
  aws_access_key_id     = Sys.getenv('AWS_ACCESS'),
  aws_secret_access_key = Sys.getenv('AWS_SECRET'),
  default.region        = Sys.getenv('AWS_REGION')
)

days_ago <- 300
response <- cost_get(from = Sys.Date() - days_ago, to = Sys.Date())

response %>%
  mutate(start = as.Date(start)) %>%
  # filter(between(start, floor_date(Sys.Date(), 'month'), Sys.Date())) %>%
  mutate(total_cost = cumsum(unblended_cost)) %>%
  pivot_longer(cols = c(unblended_cost, blended_cost, usage_quantity, total_cost)) %>%
  ggplot() +
  aes(x = as.Date(start), y = value) +
  geom_col() +
  facet_wrap(name ~ ., scales = 'free') +
  xlab(label = 'Month to Date') +
  ylab('Amount') +
  ggtitle('AWS Checkup')

response %>%
  mutate(start = as.Date(start)) %>%
  filter(between(start, floor_date(floor_date(Sys.Date(), 'month')-3, 'month'), Sys.Date())) %>%
  mutate(total_cost = cumsum(unblended_cost)) %>%
  pivot_longer(cols = c(unblended_cost, blended_cost, usage_quantity, total_cost)) %>%
  ggplot() +
  aes(x = as.Date(start), y = value) +
  geom_col() +
  facet_wrap(name ~ ., scales = 'free') +
  xlab(label = 'Month to Date') +
  ylab('Amount') +
  ggtitle('AWS Checkup')

response %>%
  mutate(start = as.Date(start)) %>%
  filter(between(start, floor_date(Sys.Date(), 'month'), Sys.Date())) %>%
  mutate(total_cost = cumsum(unblended_cost)) %>%
  pivot_longer(cols = c(unblended_cost, blended_cost, usage_quantity, total_cost)) %>%
  ggplot() +
  aes(x = as.Date(start), y = value) +
  geom_col() +
  facet_wrap(name ~ ., scales = 'free') +
  xlab(label = 'Month to Date') +
  ylab('Amount') +
  ggtitle('AWS Checkup')

ggplot(response) +
  geom_line(aes(x = as.Date(start), y = unblended_cost, colour='Cost')) +
  geom_line(aes(x = as.Date(start), y = cumsum(unblended_cost), colour='Cost')) +
  geom_line(aes(x = as.Date(start), y = log(usage_quantity), colour = 'Log of Usage Quantity'))

