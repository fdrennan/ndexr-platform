library(styler)
library(lubridate)
library(glue)
library(stringr)
library(fs)
library(uuid)

base_dir <- '/Users/fdrennan/redditor/redditor-api'
base_dir <- getwd()

dir_copy(base_dir, 'redditor-shiny/redditor-api', overwrite = TRUE)
file_copy(file.path(base_dir, 'api/plumber.R'), 'plumber.R', overwrite = TRUE)

current_time <- now(tzone = 'MST') + hours(1)
redditor::send_message(messages = glue('Package built at {current_time}'), SLACK_API_KEY = Sys.getenv('SLACK_API_KEY'))

