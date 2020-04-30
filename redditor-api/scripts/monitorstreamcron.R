library(biggr)
library(redditor)

#
# reticulate::virtualenv_install(envname = 'redditor', packages = 'praw', python = '/usr/bin/python3')
# install_python(method = 'virtualenv', envname = 'redditor')
# configure_aws(aws_access_key_id = Sys.getenv('AWS_ACCESS'),
#               aws_secret_access_key = Sys.getenv('AWS_SECRET'),
#               default.region = Sys.getenv('AWS_REGION'))
#

preferred_size <-
  as.numeric(filter(fs::dir_info(), path == 'stream.csv')$size)/1000000 > 25

if (preferred_size) {
  nowtime <- as.character(now(tzone = 'UTC'))
  nowtime <- str_replace(nowtime, ' ', '_')
  now_time_csv <- glue('stream_{nowtime}.csv')
  now_time_zip <- glue('stream_{nowtime}.zip')
  fs::file_move(path = 'stream.csv', new_path = now_time_csv)
  zip(zipfile = now_time_zip, files = now_time_csv)
  s3_upload_file(bucket = 'reddit-dumps', from = now_time_zip, to = now_time_zip, make_public = TRUE)
  file_delete(now_time_csv)
  file_delete(now_time_zip)
  sns_send_message(phone_number = Sys.getenv('MY_PHONEi i'), message = 'File uploaded')
}

