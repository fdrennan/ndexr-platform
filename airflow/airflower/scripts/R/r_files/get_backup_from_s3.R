library(biggr)
library(redditor)

s3_download_file(bucket = "reddit-dumps", to = "/data/postgres.tar.gz", from = "postgres.tar.gz")
