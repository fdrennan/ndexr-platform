#* @Plumber Example

library(plumber)
library(biggr)
library(redditor)

message("Configuring AWS")
message(Sys.getenv("AWS_ACCESS"))
message(Sys.getenv("AWS_SECRET"))
message(Sys.getenv("AWS_REGION"))
configure_aws(
  aws_access_key_id = Sys.getenv("AWS_ACCESS"),
  aws_secret_access_key = Sys.getenv("AWS_SECRET"),
  default.region = Sys.getenv("AWS_REGION")
)


#* @filter cors
cors <- function(req, res) {
  message(glue("Within filter {Sys.time()}"))

  res$setHeader("Access-Control-Allow-Origin", "*")

  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods", "*")
    res$setHeader(
      "Access-Control-Allow-Headers",
      req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS
    )
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
}


#* @serializer unboxedJSON
#* @param search_term  Stocks in JSON
#* @param limit  Stocks in JSON
#* @get /find_posts
function(search_term = "trump",
         limit = 5) {
  limit <- as.numeric(limit)

  message(glue("Within get_stocks {Sys.time()}"))

  # Build the response object (list will be serialized as JSON)
  response <- list(
    statusCode = 200,
    data = "",
    message = "Success!",
    metaData = list(
      args = list(
        search_term = search_term,
        limit = limit
      ),
      runtime = 0
    )
  )

  response <- tryCatch(
    {
      if (limit > 1000) {
        stop("You are limited to 1000 posts at a time")
      }
      # Run the algorithm
      tic()
      response$data <- find_posts(search_term = str_to_lower(search_term), limit = limit, to_json = TRUE)
      timer <- toc(quiet = T)
      response$metaData$runtime <- as.numeric(timer$toc - timer$tic)

      return(response)
    },
    error = function(err) {
      response$statusCode <- 400
      response$message <- paste(err)

      return(response)
    }
  )

  return(response)
}

#* @serializer unboxedJSON
#* @param table_name A table to grab
#* @get /get_summary
function(table_name = "meta_statistics", filter_column = NULL, filter_value = NULL) {
  message(glue("Within get_summary {Sys.time()}"))

  # Build the response object (list will be serialized as JSON)
  response <- list(
    statusCode = 200,
    data = "",
    message = "Success!",
    metaData = list(
      runtime = 0,
      table_name = table_name
    )
  )

  get_summary_temp <- function(table_name = "meta_statistics") {
    message('Before Connection')
    if (table_name == "meta_statistics") {
      con <- postgres_connector(POSTGRES_PORT = 5432, POSTGRES_HOST = Sys.getenv('POWEREDGE'))
    } else {
      con <- postgres_connector()
    }

    message('After Connection')
    print(dbListTables(con))
    on.exit(dbDisconnect(conn = con))

    table_name <- tbl(con, in_schema("public", table_name)) %>%
      collect()

    table_name
  }

  response <- tryCatch(
    {
      tic()
      response$data <- toJSON(get_summary_temp(table_name = table_name))
      timer <- toc(quiet = T)
      response$metaData$runtime <- as.numeric(timer$toc - timer$tic)
      return(response)
    },
    error = function(err) {
      response$statusCode <- 400
      response$message <- paste(err)
      return(response)
    }
  )

  return(response)
}

#* @serializer unboxedJSON
#* @param permalink
#* @get /build_submission_stack
function(permalink = "meta_statistics") {
  message(glue("Within get_summary {Sys.time()}"))

  # Build the response object (list will be serialized as JSON)
  response <- list(
    statusCode = 200,
    data = "",
    message = "Success!",
    metaData = list(
      runtime = 0,
      permalink = permalink
    )
  )

  response <- tryCatch(
    {
      tic()
      response$data <- toJSON(build_submission_stack(permalink = permalink))
      timer <- toc(quiet = T)
      response$metaData$runtime <- as.numeric(timer$toc - timer$tic)
      return(response)
    },
    error = function(err) {
      response$statusCode <- 400
      response$message <- paste(err)
      return(response)
    }
  )

  return(response)
}

#* @serializer unboxedJSON
#* @get /get_submission_files
function() {
  message(glue("Within get_summary {Sys.time()}"))

  # Build the response object (list will be serialized as JSON)
  response <- list(
    statusCode = 200,
    data = "",
    message = "Success!",
    metaData = list(
      runtime = 0
    )
  )

  response <- tryCatch(
    {
      tic()
      resp <- s3_list_objects("redditor-submissions")
      files <- glue("https://redditor-submissions.s3.us-east-2.amazonaws.com/{resp$key}")
      response$data <- toJSON(files)
      timer <- toc(quiet = T)
      response$metaData$runtime <- as.numeric(timer$toc - timer$tic)
      return(response)
    },
    error = function(err) {
      response$statusCode <- 400
      response$message <- paste(err)
      return(response)
    }
  )

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
                         timezone = "MST",
                         granularity = "5 mins",
                         add_hours = 1,
                         table = "comments",
                         width = NA,
                         height = NA) {
  width <- as.numeric(width)
  height <- as.numeric(height)

  limit <- as.numeric(limit)
  file <- "plot.png"
  p <- plot_stream(
    limit = limit,
    timezone = timezone,
    granularity = granularity,
    add_hours = add_hours,
    table = table
  )
  p
  ggsave(filename = file, plot = p, width = width, height = height)
  readBin(file, "raw", n = file.info(file)$size)
}


#* @serializer unboxedJSON
#* @param days_ago
#* @get /get_costs
function(days_ago = 300, ENV_NAME = 'XPS') {
  browser()
  message(glue("Within get_summary {Sys.time()}"))
  days_ago = as.numeric(days_ago)
  # Build the response object (list will be serialized as JSON)
  response <- list(
    statusCode = 200,
    data = "",
    message = "Success!",
    metaData = list(
      runtime = 0,
      days_ago = days_ago
    )
  )

  response <- tryCatch(
    {
      tic()
      results <- cost_get(from = as.character(Sys.Date() - days_ago), to = as.character(Sys.Date()))
      response$data <- toJSON(results)
      timer <- toc(quiet = T)
      response$metaData$runtime <- as.numeric(timer$toc - timer$tic)
      return(response)
    },
    error = function(err) {
      response$statusCode <- 400
      response$message <- paste(err)
      return(response)
    }
  )

  return(response)
}

