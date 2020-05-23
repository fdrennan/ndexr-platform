library(fs)
library(biggr)
s3_download_file(bucket = "redditor-dumps", to = "/backup/postgres_aws.tar.gz", from = "postgres.tar.gz")
