library(styler)
library(lubridate)
library(glue)
library(stringr)
library(fs)
library(uuid)

base_dir <- "/home/fdrennan/ndexr-platform/redditor-api"

style_dir(base_dir)
style_dir("/home/fdrennan/ndexr-platform/airflow/airflower/scripts/R/r_files")
style_dir(file.path(base_dir, "R"))
style_dir(file.path("/home/fdrennan/ndexr-platform/", 'redditor-shiny'))
devtools::install(base_dir)
dir_copy(base_dir, 'redditor-shiny/redditor-api', overwrite = TRUE)

current_time <- now(tzone = "MST") + hours(1)
redditor::send_message(messages = glue("Package built at {current_time}"), SLACK_API_KEY = Sys.getenv('SLACK_API_KEY'))

