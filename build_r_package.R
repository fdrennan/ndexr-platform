library(styler)
library(lubridate)
library(glue)
library(stringr)

base_dir <- "/Users/fdrennan/redditor/redditor-api"

style_dir(base_dir)
style_dir(file.path(base_dir, "R"))

devtools::install(base_dir)

current_time <- now(tzone = "MST") + hours(1)
redditor::send_message(messages = glue("Package built at {current_time}"), SLACK_API_KEY = Sys.getenv('SLACK_API_KEY'))