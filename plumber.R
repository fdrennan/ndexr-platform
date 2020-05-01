#* @Plumber Example

library(plumber)
library(redditor)
#* @filter cors
cors <- function(req, res) {
  message(glue('Within filter {Sys.time()}'))

  res$setHeader("Access-Control-Allow-Origin", "*")

  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods", "*")
    res$setHeader("Access-Control-Allow-Headers",
                  req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }

}

#* @serializer unboxedJSON
#* @param key  Stocks in JSON
#* @param limit  Stocks in JSON
#* @get /find_posts
function(key = 'trump',
         limit = 5) {

  limit = as.numeric(limit)

  message(glue('Within get_stocks {Sys.time()}'))

  # Build the response object (list will be serialized as JSON)
  response <- list(
    statusCode = 200,
    data = "",
    message = "Success!",
    metaData = list(
      args = list(
        key = key,
        limit = limit
      ),
      runtime = 0
    )
  )

  response <- tryCatch({
    if (limit > 1000) {
      stop('You are limited to 1000 posts at a time')
    }
    # Run the algorithm
    tic()
    response$data <- find_posts(key = str_to_lower(key), limit = limit, to_json = TRUE)
    timer <- toc(quiet = T)
    response$metaData$runtime <- as.numeric(timer$toc - timer$tic)

    return(response)
  },
  error = function(err) {
    response$statusCode <- 400
    response$message <- paste(err)

    return(response)
  })

  return(response)

}

#* @serializer unboxedJSON
#* @get /get_summary
function() {

  limit = as.numeric(limit)

  message(glue('Within get_stocks {Sys.time()}'))

  # Build the response object (list will be serialized as JSON)
  response <- list(
    statusCode = 200,
    data = "",
    message = "Success!",
    metaData = list(
      runtime = 0
    )
  )

  response <- tryCatch({
    if (limit > 1000) {
      stop('You are limited to 1000 posts at a time')
    }
    # Run the algorithm
    tic()
    response$data <- toJSON(get_summary())
    timer <- toc(quiet = T)
    response$metaData$runtime <- as.numeric(timer$toc - timer$tic)

    return(response)
  },
  error = function(err) {
    response$statusCode <- 400
    response$message <- paste(err)

    return(response)
  })

  return(response)

}


#* @serializer contentType list(type='image/png')
#* @param limit
#* @param timezone
#* @param granularity
#* @param add_hours
#* @param table
#* @param width
#* @param height
#* @get /comment_plot
comment_plot <- function(limit = 600,
                         timezone='MST',
                         granularity = '5 mins',
                         add_hours = 1,
                         table = 'comments',
                         width = NA,
                         height = NA) {

  width = as.numeric(width)
  height = as.numeric(height)

  limit = as.numeric(limit)
  file <- 'plot.png'
  p <- plot_stream(limit = limit,
                   timezone = timezone,
                   granularity = granularity,
                   add_hours = add_hours,
                   table = table)
  p
  ggsave(filename = file, plot = p, width = width, height = height)
  readBin(file,'raw', n = file.info(file)$size)
}
