library(styler)
library(lubridate)
library(glue)
library(stringr)
library(fs)
library(uuid)

base_dir <- "/Users/fdrennan/redditor/redditor-api"

style_dir(base_dir)
style_dir("/Users/fdrennan/redditor/airflow/airflower/scripts/R/r_files")
style_dir(file.path(base_dir, "R"))
style_dir(file.path("/Users/fdrennan/redditor/", 'redditor-shiny'))

#if (!"httpuv" %in% as.data.frame(installed.packages())$Package) {
#  withr::with_makevars(
#    c(PKG_CPPFLAGS = "-DDEBUG_TRACE -DDEBUG_THREAD -UNDEBUG",
#      CFLAGS="-g -O3 -Wall -pedantic -std=gnu99 -mtune=native -pipe -D__USE_MISC"),
#    {
#      devtools::install_github("rstudio/httpuv")
#    },
#    assignment = "+="
#  )
#}

#devtools::install(base_dir)
dir_copy(base_dir, 'redditor-shiny/redditor-api', overwrite = TRUE)

current_time <- now(tzone = "MST") + hours(1)
redditor::send_message(messages = glue("Package built at {current_time}"), SLACK_API_KEY = Sys.getenv('SLACK_API_KEY'))

