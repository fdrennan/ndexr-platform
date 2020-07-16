library(redditor)
library(future)
library(httr)
library(jsonlite)
library(openxlsx)
library(scales)
library(shinyBS)
library(shinycssloaders)
# library(shinyLP)

options(shiny.sanitize.errors = FALSE)
print(py_config())
print(system("whoami"))

# con <- postgres_connector()
# reddit <- reddit_connector()
# reddit_con <- reddit_connector()
# LENOVO <- Sys.getenv("LENOVO")
# curl -X GET "http://127.0.0.1:9798/get_summary" -H  "accept: application/json"

build_datatable <- function(the_datatable) {
  datatable(the_datatable,
    extensions = c("Buttons", "Scroller"),
    options = list(
      scrollY = 650,
      scrollX = 500,
      deferRender = TRUE,
      scroller = TRUE,
      fixedColumns = TRUE,
      # paging = TRUE,
      # pageLength = 25,
      buttons = list( #' excel',
        list(extend = "colvis", targets = 0, visible = FALSE)
      ),
      dom = "lBfrtip",
      fixedColumns = TRUE
    ),
    rownames = FALSE
  )
}


ui <- dashboardPage(
  skin = "black",
  # tags$header(includeHTML(("google-analytics.html"))),
  dashboardHeader(
    title = "NDEX for Reddit"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("chart-bar")),
      menuItem("Search", tabName = "search", icon = icon("search-plus")),
      menuItem("Submission Deconstructor", tabName = "permalink", icon = icon("comments")),
      menuItem("Production Links", tabName = "links", icon = icon("dashboard")),
      menuItem("Cost Summary", tabName = "costs", icon = icon("money"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "costs",
        bsCollapse(
          id = "costcollapse", open = "Monthly Cost Activity",
          bsCollapsePanel(
            "Monthly Cost Activity",
            fluidRow(
              box(withSpinner(plotOutput("costReportMonth")), width = 12)
            )
          )
        ),
        bsCollapse(
          id = "costcollapse", open = "Historical Cost Activity",
          bsCollapsePanel(
            "Historical Cost Activity",
            fluidRow(
              box(withSpinner(plotOutput("costReportYear")), width = 12),
            )
          )
        ),
        bsCollapse(
          id = "costcollapse", open = "Prior Month Cost Activity",
          bsCollapsePanel(
            "Prior Month Cost Activity",
            fluidRow(
              box(withSpinner(plotOutput("costReportPrior")), width = 12),
            )
          )
        ),
      ),
      tabItem(
        tabName = "dashboard",
        fluidRow(
          # Using a custom container and class
          # tags$ul(
          #   htmlOutput("summary", container = tags$li, class = "custom-li-output")
          # ),
          # Dynamic infoBoxes
          # http://ndexr.com/api/construction_rmd
          # shinyLP::iframe(url_link = "http://ndexr.com/api/construction_rmd"),
          # HTML(read_file_r("http://facebook.com")),
          # tags$iframe(src="http://facebook.com", height=600, width=535 ),
          # shinyLP::iframe(width = "560", height = "315",url_link = "https://www.youtube.com/embed/0fKg7e37bQE"),
          # tags$iframe(src = "www.rstudio.com", seamless=NA),
          
          box(
            withSpinner(infoBoxOutput("submissionsBox", width = 4)),
            infoBoxOutput("authorsBox", width = 4),
            infoBoxOutput("subredditsBox", width = 4),
            width = 12
          )
        ),
        fluidRow(
          box(withSpinner(plotOutput("all_time_submissions")), width = 12),
        )
      ),
      tabItem(
        tabName = "search",
        bsCollapse(
          id = "submissioncollapse", open = "Submission Query Menu",
          bsCollapsePanel(
            "Submission Query Menu",
            fluidRow(
              box(
                title = "Search Parameters",
                column(textInput(
                  inputId = "search_value", label = "Query Data",
                  value = "Natural Language Processing",
                  placeholder = "Natural Language Processing"
                ), width = 9),
                column(numericInput(inputId = "limit", label = "Limit", value = 200, min = 0, max = 20000), width = 9),
              ),
              box(
                title = "Options",
                column(downloadButton("downloadData", "Download"), width = 6),
                column(checkboxInput("removensfw", "Remove NSFW", TRUE), width = 6)
              )
            )
          )
        ),
        bsCollapse(
          id = "submissioncollapse", open = "Submission Results",
          bsCollapsePanel(
            "Submission Results",
            fluidRow(
              column(withSpinner(dataTableOutput("search_data")), width = 12)
            )
          )
        ),
        bsCollapse(
          id = "submissioncollapse", open = "Image Results",
          bsCollapsePanel(
            "Image Results",
            fluidRow(
              column(withSpinner(uiOutput("imageOutput")), width = 12)
            )
          )
        )
      ),
      tabItem(
        tabName = "permalink",
        fluidRow(
          box(title = "Submit any Reddit Permalink to see threads decomposed", textInput(inputId = "permalink", label = "Permalink", value = "/r/SeriousConversation/comments/gteetu/you_know_what_would_significantly_impact_police/"), width = 12),
          box(
            bsCollapse(
              id = "submissioncollapse", open = "Submission Comments",
              bsCollapsePanel(
                "Submission Comments",
                column(withSpinner(dataTableOutput("permalink_summary")), width = 12)
              )
            ),
            bsCollapse(
              id = "submissioncollapse", open = "Comment Threads",
              bsCollapsePanel(
                "Comment Threads",
                column(withSpinner(dataTableOutput("permalink_data")), width = 12)
              )
            ),
            width = 12
          )
        )
      ),
      tabItem(
        tabName = "links",
        fluidPage(
          box(tags$h1("Public Routes", align = "center"), width = 12, background = "light-blue"),
          box(
            tags$a(
              href = "https://us-east-2.console.aws.amazon.com/console/home?region=us-east-2",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/aws.png",
                title = "AWS Console",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "https://github.com/fdrennan/ndexr-platform",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/github.png",
                title = "Get the Repo",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "https://join.slack.com/t/ndexr/shared_invite/zt-fhxk2scl-Y9BeA~JZUoTiDLVk~6degQ",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/joinslack.jpg",
                title = "Join Slack",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "http://ndexr.com/elastic",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/elasticsearch.jpeg",
                title = "Elastic Search",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "http://ndexr.com/api/get_submission_files",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/plumber.png",
                title = "Plumber",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(tags$h1("Private Routes", align = "center"), width = 12, background = "light-blue"),
          box(
            tags$a(
              href = "http://ndexr.com:8080",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/airflow.png",
                title = "Airflow",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "http://ndexr.com:8787",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/rstudio.png",
                title = "Rstudio Server",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "http://ndexr.com:8000",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/jupyterhub.svg",
                title = "Jupyterhub",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "http://ndexr.com:8081",
              tags$image(
                src = "https://ndexr-images.s3.us-east-2.amazonaws.com/pgadmin.png",
                title = "PG Admin",
                width = "100%"
              )
            ),
            width = 3
          ),
          box(tags$h1("Monitoring", align = "center"), width = 12, background = "light-blue"),
          box(
            tags$a(
              href = "http://ndexr.com:61211",
              tags$h1('Poweredge')
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "http://ndexr.com:61209",
              tags$h1('Lenovo')
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "http://ndexr.com:61208",
              tags$h1('EC2')
            ),
            width = 3
          ),
          box(
            tags$a(
              href = "http://ndexr.com:61210",
              tags$h1('XPS')
            ),
            width = 3
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {

  
  resp <- GET(url = glue("http://ndexr.com/api/get_summary"), query = list(table_name = "poweredge_meta_statistics", host_variable = "XPS"))
  meta_statistics <- fromJSON(fromJSON(content(resp, "text"))$data)
  resp <- GET(url = glue("http://ndexr.com/api/get_summary"), query = list(table_name = "counts_by_minute"))
  counts_by_second <- fromJSON(fromJSON(content(resp, "text"))$data)

  elastic_results <- reactive({
    data <- find_posts(search_term = input$search_value, limit = input$limit, table_name = "submissions")
    if (input$removensfw) {
      data <- data[!as.logical(data$over_18), ]
    }
    data <-
      data %>%
      mutate_all(as.character) %>%
      as_tibble()

    data
  })

  output$submissionsBox <- renderInfoBox({
    infoBox(
      "Submissions Gathered", comma(filter(as.data.frame(meta_statistics), type == "submissions")$value),
      icon = icon("list"),
      color = "aqua"
    )
  })

  output$subredditsBox <- renderInfoBox({
    infoBox(
      "Subreddits Discovered", comma(filter(as.data.frame(meta_statistics), type == "subreddits")$value),
      icon = icon("list"),
      color = "aqua"
    )
  })

  output$authorsBox <- renderInfoBox({
    infoBox(
      "Authors Discovered", comma(filter(
        as.data.frame(meta_statistics),
        type == "authors"
      )$value),
      icon = icon("list"),
      color = "aqua"
    )
  })

  output$all_time_submissions <- renderPlot({
    time_ago <- round(as.numeric(Sys.time() - ymd_hms(max(counts_by_second$created_utc))), 2)
    message_about_time <- glue("Last updated {time_ago} minutes ago")

    counts_by_second %>%
      mutate(
        created_utc = floor_date(ymd_hms(created_utc), unit = "15 minutes"),
        created_utc = with_tz(created_utc, tzone = "America/Denver"),
        n_observations = as.numeric(n_observations)
      ) %>%
      group_by(created_utc) %>%
      summarise(n_observations = sum(n_observations)) %>%
      ggplot() +
      aes(x = created_utc, y = n_observations) +
      geom_col() +
      xlab("Created At (MST)") +
      ylab("Submissions Gathered") +
      scale_x_datetime(date_breaks = "2 hour", date_labels = "%Y-%m-%d %H:%M") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
      ggtitle(label = "Recently gathered submissions", subtitle = message_about_time)
  })



  output$downloadData <- downloadHandler(
    filename = function() {
      paste("output", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(elastic_results(), file, row.names = FALSE)
    }
  )

  output$search_data <- renderDataTable({
    response <- elastic_results()
    response <- response %>%
      rename_all(function(x) {
        x %>%
          str_replace_all("_", " ") %>%
          str_to_title()
      })

    build_datatable(response)
  })

  output$imageOutput <- renderUI({
    images_to_show <- elastic_results()$url
    print(images_to_show[!str_detect(images_to_show, "www.reddit.com")])
    images_to_show <- images_to_show[!str_detect(images_to_show, "www.reddit.com")]
    map(
      unique(images_to_show),
      function(x) {
        if (str_detect(x, "youtube")) {
          type_logic <- "youtube"
        } else if (str_detect_any(x, c(".jpg", ".png", ".jpeg", ".gif"))) {
          type_logic <- "image"
        } else {
          type_logic <- "unknown"
        }

        if (type_logic == "image") {
          response <- box(
            tags$a(
              href = x,
              tags$img(
                src = x,
                title = x,
                width = "100%"
              )
            ),
            width = 3
          )
        } else {
          # response <-tags$a(
          #   href = x,
          #   title = x,
          #   tags$div(tags$text(x, align='center'))
          # )
          response <- tags$div()
        }
        return(response)
      }
    )
  })
  #
  current_permalink <- reactive({
    resp <- GET(url = glue("http://ndexr.com/api/build_submission_stack"), query = list(permalink = input$permalink))
    response <- fromJSON(fromJSON(content(x = resp, as = "text"))$data)
    response
  })

 
  output$permalink_summary <- renderDataTable({
    summarise_thread_stack(current_permalink()) %>%
      arrange(desc(engagement_ratio))
    # build_datatable
  })

  output$permalink_data <- renderDataTable({
    response <-
      current_permalink() %>%
      select(thread_number, created_utc, author, body, everything())

    build_datatable(response)
  })
  
  resp <- GET(url = glue("http://ndexr.com/api/get_summary"), query = list(table_name = "costs", host_variable = "XPS"))
  get_costs <- fromJSON(fromJSON(content(resp, 'text'))$data)

  output$costReportYear <- renderPlot({

    get_costs %>%
      mutate(start = as.Date(start)) %>%
      # filter(between(start, floor_date(Sys.Date(), 'month'), Sys.Date())) %>%
      mutate(total_cost = cumsum(unblended_cost)) %>%
      pivot_longer(cols = c(unblended_cost, blended_cost, usage_quantity, total_cost)) %>%
      ggplot() +
      aes(x = as.Date(start), y = value) +
      geom_col() +
      facet_wrap(name ~ ., scales = 'free') +
      xlab(label = 'Month to Date') +
      ylab('Amount') +
      ggtitle('AWS Checkup')
  })

  output$costReportPrior <- renderPlot({
    get_costs %>%
      mutate(start = as.Date(start)) %>%
      filter(between(start, floor_date(floor_date(Sys.Date(), 'month')-3, 'month'), Sys.Date())) %>%
      mutate(total_cost = cumsum(unblended_cost)) %>%
      pivot_longer(cols = c(unblended_cost, blended_cost, usage_quantity, total_cost)) %>%
      ggplot() +
      aes(x = as.Date(start), y = value) +
      geom_col() +
      facet_wrap(name ~ ., scales = 'free') +
      xlab(label = 'Month to Date') +
      ylab('Amount') +
      ggtitle('AWS Checkup')
  })

  output$costReportMonth <- renderPlot({
    cost_df <- get_costs %>%
      mutate(start = as.Date(start)) %>%
      filter(between(start, floor_date(Sys.Date(), 'month'), Sys.Date())) %>%
      mutate(total_cost = cumsum(unblended_cost))

    cost_df_sum <- sum(cost_df$unblended_cost, na.rm = TRUE)

    cost_df %>%
      pivot_longer(cols = c(unblended_cost, blended_cost, usage_quantity, total_cost)) %>%
      ggplot() +
      aes(x = as.Date(start), y = value) +
      geom_col() +
      facet_wrap(name ~ ., scales = 'free') +
      xlab(label = 'Month to Date') +
      ylab('Amount') +
      ggtitle(glue('AWS Checkup: Month to Date Cost {cost_df_sum}'))
  })


}

shinyApp(ui, server)
