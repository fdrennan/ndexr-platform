library(biggr)
library(redditor)

backup_submissions_to_s3(keep_days = 1)
send_message("backup_submissions_to_s3 ran")
