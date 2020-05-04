library(biggr)
library(redditor)

tar('/postgres.tar.gz', '/postgres.bak', compression = 'gzip', tar="tar")
s3_upload_file(bucket = 'reddit-dumps', from = '/postgres.tar.gz', to = 'postgres.tar.gz', make_public = TRUE)
file_delete('/postgres.tar.gz')
