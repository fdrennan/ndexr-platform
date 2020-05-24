# Title     : TODO
# Objective : TODO
# Created by: fdrennan
# Created on: 5/14/20

library(biggr)
library(ipify)

my_ip <- get_ip()
sgd <- security_group_data()

# FOR SSH
ips <- sgd %>%
  filter(group_name == "Router", from_port == 22)

current_ip <-
  ips %>%
  filter(str_detect(ip_ranges, my_ip))

if (nrow(current_ip) == 0) {
  security_group_revoke(sg_name = "Router", ports = 22, ips = str_remove_all(ips$ip_ranges, "/32"))
  my_ip <- get_ip()
  security_group_envoke(sg_name = "Router", ports = 22, ips = my_ip)
}

# FOR DATABASE
ips <- sgd %>%
  filter(group_name == "Router", from_port == 5432)

current_ip <-
  ips %>%
  filter(str_detect(ip_ranges, my_ip))

if (nrow(current_ip) == 0) {
  security_group_revoke(sg_name = "Router", ports = 5432, ips = str_remove_all(ips$ip_ranges, "/32"))
  my_ip <- get_ip()
  security_group_envoke(sg_name = "Router", ports = 5432, ips = my_ip)
}
